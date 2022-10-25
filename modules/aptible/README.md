# Aptible Metrics Resources

This module is responsible for managing the Aptible resources (and the Grafana
data source) necessary to collect and store container metrics.

## Dependencies

This module depends on the
[Aptible CLI](https://deploy-docs.aptible.com/docs/cli) in order to set up the
PostgreSQL Database to manage Grafana sessions.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aptible"></a> [aptible](#requirement\_aptible) | ~> 0.5.1 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~> 1.29.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aptible"></a> [aptible](#provider\_aptible) | ~> 0.5.1 |
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | ~> 1.29.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_influx_url"></a> [influx\_url](#module\_influx\_url) | ../database_url | n/a |
| <a name="module_pg_url"></a> [pg\_url](#module\_pg\_url) | ../database_url | n/a |

## Resources

| Name | Type |
|------|------|
| [aptible_app.grafana](https://registry.terraform.io/providers/aptible/aptible/latest/docs/resources/app) | resource |
| [aptible_app.psql](https://registry.terraform.io/providers/aptible/aptible/latest/docs/resources/app) | resource |
| [aptible_database.influx](https://registry.terraform.io/providers/aptible/aptible/latest/docs/resources/database) | resource |
| [aptible_database.postgres](https://registry.terraform.io/providers/aptible/aptible/latest/docs/resources/database) | resource |
| [aptible_endpoint.grafana_endpoint](https://registry.terraform.io/providers/aptible/aptible/latest/docs/resources/endpoint) | resource |
| [aptible_metric_drain.this](https://registry.terraform.io/providers/aptible/aptible/latest/docs/resources/metric_drain) | resource |
| [grafana_data_source.influx](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) | resource |
| [null_resource.sessions_table](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.gf_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.gf_db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.gf_secret_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aptible_environment.drains](https://registry.terraform.io/providers/aptible/aptible/latest/docs/data-sources/environment) | data source |
| [aptible_environment.metrics](https://registry.terraform.io/providers/aptible/aptible/latest/docs/data-sources/environment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_metrics_environment"></a> [metrics\_environment](#input\_metrics\_environment) | The handle of the environment to send metrics to. This can be one of the drain\_environments. | `string` | n/a | yes |
| <a name="input_drain_environments"></a> [drain\_environments](#input\_drain\_environments) | The handles of the environments to drain metrics from. By default only the metrics\_environment will be drained. | `list(string)` | `null` | no |
| <a name="input_grafana_container_count"></a> [grafana\_container\_count](#input\_grafana\_container\_count) | The number of Grafana App containers to deploy. | `number` | `null` | no |
| <a name="input_grafana_container_profile"></a> [grafana\_container\_profile](#input\_grafana\_container\_profile) | The instance profile of the Grafana App containers. | `string` | `null` | no |
| <a name="input_grafana_container_size"></a> [grafana\_container\_size](#input\_grafana\_container\_size) | The size (in MB) of the Grafana App containers. | `number` | `null` | no |
| <a name="input_grafana_db_user"></a> [grafana\_db\_user](#input\_grafana\_db\_user) | The user that Grafana will use to access the PostgreSQL Database. This user is created and granted the necessary permissions on the Database. | `string` | `"grafana"` | no |
| <a name="input_grafana_endpoint_domain"></a> [grafana\_endpoint\_domain](#input\_grafana\_endpoint\_domain) | The custom domain for the Grafana Endpoint to use. By default the App's default domain will be used. Wildcard domains are not supported. | `string` | `null` | no |
| <a name="input_grafana_handle"></a> [grafana\_handle](#input\_grafana\_handle) | The handle to use for the Grafana App. | `string` | `"grafana"` | no |
| <a name="input_grafana_image_tag"></a> [grafana\_image\_tag](#input\_grafana\_image\_tag) | The grafana/grafana image tag (i.e. version) that the app will use. | `string` | `"latest"` | no |
| <a name="input_influx_container_profile"></a> [influx\_container\_profile](#input\_influx\_container\_profile) | The instance profile of the InfluxDB metrics Database container. | `string` | `null` | no |
| <a name="input_influx_container_size"></a> [influx\_container\_size](#input\_influx\_container\_size) | The size (in MB) of the InfluxDB metrics Database container. | `number` | `null` | no |
| <a name="input_influx_handle"></a> [influx\_handle](#input\_influx\_handle) | The handle to use for the InfluxDB Database used to store metrics. | `string` | `"influx"` | no |
| <a name="input_postgres_container_profile"></a> [postgres\_container\_profile](#input\_postgres\_container\_profile) | The instance profile of the PostgreSQL Grafana Database container. | `string` | `null` | no |
| <a name="input_postgres_container_size"></a> [postgres\_container\_size](#input\_postgres\_container\_size) | The size (in MB) of the PostgreSQL Grafana Database container. | `number` | `null` | no |
| <a name="input_postgres_handle"></a> [postgres\_handle](#input\_postgres\_handle) | The handle to use for the PostgreSQL Database used for storing Grafana data. | `string` | `"pg-grafana"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aptible_influx_database"></a> [aptible\_influx\_database](#output\_aptible\_influx\_database) | The Aptible InfluxDB Database where metrics are stored. |
| <a name="output_grafana_admin_password"></a> [grafana\_admin\_password](#output\_grafana\_admin\_password) | The password for the admin Grafana user. |
| <a name="output_grafana_auth"></a> [grafana\_auth](#output\_grafana\_auth) | An auth string that can be used to access Grafana. |
| <a name="output_grafana_data_source"></a> [grafana\_data\_source](#output\_grafana\_data\_source) | The grafana\_data\_source corresponding to the InfluxDB Database in the metrics\_environment. |
| <a name="output_grafana_db_password"></a> [grafana\_db\_password](#output\_grafana\_db\_password) | The password for the Grafana PostgreSQL user. |
| <a name="output_grafana_db_user"></a> [grafana\_db\_user](#output\_grafana\_db\_user) | The PostgreSQL user that Grafana will use to manage its data. |
| <a name="output_grafana_endpoint"></a> [grafana\_endpoint](#output\_grafana\_endpoint) | The Grafana App's public Endpoint. Used to set up DNS records for custom domains. |
| <a name="output_grafana_url"></a> [grafana\_url](#output\_grafana\_url) | The Grafana App's public URL. |
| <a name="output_influx_database_name"></a> [influx\_database\_name](#output\_influx\_database\_name) | The name of the InfluxDB database where metrics are stored. |
<!-- END_TF_DOCS -->
