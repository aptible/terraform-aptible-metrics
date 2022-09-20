# Aptible Metrics Terraform Module

This terraform module is designed to make it simple to manage "self-hosted"
metrics collection and monitoring for Aptible Environments on Aptible. It
includes two submodules for managing resources:

## `modules/aptible`

This module is responsible for managing the Aptible resources (and the Grafana
data source) necessary to collect and store metrics. This module likely won't be
used directly unless Grafana dashboards are being managed elsewhere.

### Dependencies

- [Aptible CLI](https://deploy-docs.aptible.com/docs/cli)
- [PostgreSQL CLI Client Tools](https://www.postgresql.org/download/)

This module depends on the Aptible CLI in order to support managing metric
drains. It also depends on the `psql` and`pg_isready` PostgreSQL client tools to
configure the PostgreSQL Database for Grafana to use.

## `modules/grafana`

This module is responsible for managing the Grafana resources necessary to
visualize and monitor the collected metrics. This module is useful on its own
for applying the Grafana dashboards and alert rules to an existing Grafana
instance. The module creates its own folder for the resources it manages so as
to not interfere with other resources.
