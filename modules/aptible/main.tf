terraform {
  required_providers {
    aptible = {
      source = "aptible.com/aptible/aptible"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "1.29.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

locals {
  drain_environments = toset(var.drain_environments != null ? var.drain_environments : [var.metrics_environment])
}

# Environments
# The Environment that metrics are sent to
data "aptible_environment" "metrics" {
  handle = var.metrics_environment
}

# The Environments being drained
data "aptible_environment" "drains" {
  for_each = local.drain_environments

  handle = each.value
}

# Databases
# The InfluxDB database where metrics will be stored
resource "aptible_database" "influx" {
  handle            = var.influx_handle
  env_id            = data.aptible_environment.metrics.env_id
  database_type     = "influxdb"
  container_size    = var.influx_container_size
  container_profile = var.influx_container_profile
}

# The PostgreSQL database where Grafana's data will be stored
resource "aptible_database" "postgres" {
  handle            = var.postgres_handle
  env_id            = data.aptible_environment.metrics.env_id
  database_type     = "postgresql"
  container_size    = var.postgres_container_size
  container_profile = var.postgres_container_profile
}

# Database URLs
module "influx_url" {
  source = "../database_url"
  url    = aptible_database.influx.default_connection_url
}

module "pg_url" {
  source = "../database_url"
  url    = aptible_database.postgres.default_connection_url
}

# Passwords
locals {
  override_special = "-_"
}

resource "random_password" "gf_db_password" {
  length           = 24
  override_special = local.override_special
}

resource "random_password" "gf_admin_password" {
  length           = 24
  override_special = local.override_special
}

resource "random_password" "gf_secret_key" {
  length           = 24
  override_special = local.override_special
}

# Ensure PG database has necessary tables
# Some providers exist to create database objects but we don't have a way to set
# up the tunnel in order to reach the database so use an Aptible App
resource "aptible_app" "psql" {
  env_id = data.aptible_environment.metrics.env_id
  handle = "psql-${data.aptible_environment.metrics.handle}"
  service {
    process_type    = "cmd"
    container_count = 0
  }
  config = {
    "APTIBLE_DOCKER_IMAGE" = "postgres"
  }
}

resource "null_resource" "sessions_table" {
  triggers = {
    database_id = aptible_database.postgres.database_id
    user        = var.grafana_db_user
    password    = random_password.gf_db_password.result
  }

  provisioner "local-exec" {
    working_dir = path.module
    command = <<-EOT
    aptible ssh --environment ${data.aptible_environment.metrics.handle} --app ${aptible_app.psql.handle} bash -c "$(cat << EOF
      psql '${aptible_database.postgres.default_connection_url}' << EOQ
        ${templatefile("${path.module}/create_sessions.tftpl.sql", {
    username = var.grafana_db_user
    password = random_password.gf_db_password.result
})}
    EOQ
    EOF
    )"
    EOT
}
}

# Create metric drain
# The provider doesn't currently support this type of resource
locals {
  influx_database_url  = "${module.influx_url.scheme}://${module.influx_url.host}:${module.influx_url.port}"
  influx_database_name = module.influx_url.database != null ? module.influx_url.database : "db"
}

resource "aptible_metric_drain" "this" {
  for_each = data.aptible_environment.drains

  env_id     = each.value.env_id
  handle     = "influx-${each.value.handle}"
  drain_type = "influxdb"
  url        = local.influx_database_url
  username   = module.influx_url.user
  password   = module.influx_url.password
  database   = local.influx_database_name
}

# Apps
resource "aptible_app" "grafana" {
  env_id = data.aptible_environment.metrics.env_id
  handle = var.grafana_handle
  service {
    process_type           = "cmd"
    container_count        = var.grafana_container_count
    container_memory_limit = var.grafana_container_size
    container_profile      = var.grafana_container_profile
  }
  config = {
    "APTIBLE_DOCKER_IMAGE"       = "grafana/grafana:${var.grafana_image_tag}"
    "FORCE_SSL"                  = "true"
    "GF_SECURITY_ADMIN_PASSWORD" = random_password.gf_admin_password.result
    "GF_SECURITY_SECRET_KEY"     = random_password.gf_secret_key.result
    "GF_DEFAULT_INSTANCE_NAME"   = "aptible"
    "GF_SESSION_PROVIDER"        = "postgres"
    "GF_SESSION_PROVIDER_CONFIG" = "user=${var.grafana_db_user} password=${random_password.gf_db_password.result} host=${module.pg_url.host} port=${module.pg_url.port} dbname=sessions sslmode=require"
    "GF_LOG_MODE"                = "console"
    "GF_DATABASE_TYPE"           = "postgres"
    "GF_DATABASE_HOST"           = "${module.pg_url.host}:${module.pg_url.port}"
    "GF_DATABASE_NAME"           = "db"
    "GF_DATABASE_USER"           = "${var.grafana_db_user}"
    "GF_DATABASE_PASSWORD"       = "${random_password.gf_db_password.result}"
    "GF_DATABASE_SSL_MODE"       = "require"
  }
  depends_on = [null_resource.sessions_table]
}

# Endpoints
resource "aptible_endpoint" "grafana_endpoint" {
  env_id         = data.aptible_environment.metrics.env_id
  resource_id    = aptible_app.grafana.app_id
  resource_type  = "app"
  process_type   = "cmd"
  default_domain = var.grafana_endpoint_domain == null
  domain         = var.grafana_endpoint_domain
  endpoint_type  = "https"
  managed        = var.grafana_endpoint_domain != null
  platform       = "alb"
}

# Grafana data source
locals {
  grafana_url  = "https://${aptible_endpoint.grafana_endpoint.virtual_domain}"
  grafana_auth = "admin:${random_password.gf_admin_password.result}"
}

provider "grafana" {
  url  = local.grafana_url
  auth = local.grafana_auth
}

resource "grafana_data_source" "influx" {
  name          = "aptible-influx"
  type          = "influxdb"
  url           = local.influx_database_url
  database_name = local.influx_database_name
  username      = module.influx_url.user
  secure_json_data_encoded = jsonencode({
    password = module.influx_url.password
  })
}
