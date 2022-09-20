terraform {
  required_providers {
    aptible = {
      source  = "aptible/aptible"
      version = "0.3.1"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "1.28.2"
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
# The environment being drained
data "aptible_environment" "drains" {
  for_each = toset(local.drain_environments)

  handle = each.value
}

# The environment that metrics are sent to
data "aptible_environment" "metrics" {
  handle = var.metrics_environment
}

# Databases
# The influx database where metrics will be stored
resource "aptible_database" "influx" {
  handle        = "influx"
  env_id        = data.aptible_environment.metrics.env_id
  database_type = "influxdb"
}

# The PG database where grafana's data will be stored
resource "aptible_database" "postgres" {
  handle        = "pg-grafana"
  env_id        = data.aptible_environment.metrics.env_id
  database_type = "postgresql"
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
# up the tunnel in order to reach the database
resource "null_resource" "sessions_table" {
  triggers = {
    env_id      = data.aptible_environment.metrics.id
    database_id = aptible_database.postgres.database_id
    user        = var.grafana_db_user
    password    = random_password.gf_db_password.result
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "./pg_create_sessions.sh '${data.aptible_environment.metrics.handle}' '${aptible_database.postgres.handle}' '${aptible_database.postgres.default_connection_url}' '${self.triggers.user}' '${self.triggers.password}'"
  }
}

# Create metric drain
# The provider doesn't currently support this type of resource
locals {
  influx_database_name = module.influx_url.database != null ? module.influx_url.database : "db"
}

resource "null_resource" "metric_drain" {
  for_each = data.aptible_environment.drains

  triggers = {
    env_id       = each.value.env_id
    env_handle   = each.value.handle
    drain_handle = "influx-${each.value.handle}"
    drain_url    = aptible_database.influx.default_connection_url
  }

  provisioner "local-exec" {
    command = "aptible metric_drain:create:influxdb:custom '${self.triggers.drain_handle}' --environment '${self.triggers.env_handle}' --username '${module.influx_url.user}' --password '${module.influx_url.password}' --url '${module.influx_url.scheme}://${module.influx_url.host}:${module.influx_url.port}' --db '${local.influx_database_name}'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aptible metric_drain:deprovision '${self.triggers.drain_handle}' --environment '${self.triggers.env_handle}'"
  }
}

# Apps
resource "aptible_app" "grafana" {
  handle = "grafana"
  env_id = data.aptible_environment.metrics.env_id
  service {
    process_type           = "cmd"
    container_count        = 1
    container_memory_limit = 1024
  }
  config = {
    "APTIBLE_DOCKER_IMAGE"       = "grafana/grafana:${var.grafana_image_tag}"
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
    "FORCE_SSL"                  = "true"
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
  url           = "${module.influx_url.scheme}://${module.influx_url.host}:${module.influx_url.port}"
  database_name = local.influx_database_name
  username      = module.influx_url.user
  secure_json_data_encoded = jsonencode({
    password = module.influx_url.password
  })
}
