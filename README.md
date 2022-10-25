# Aptible Metrics Terraform Module

This terraform module is designed to make it simple to manage "self-hosted"
metrics collection and monitoring for Aptible Environments on Aptible. It
includes two submodules for managing resources:

## [`modules/aptible`](./modules/grafana)

This module is responsible for managing the Aptible resources (and the Grafana
data source) necessary to collect and store container metrics.

### Dependencies

This module depends on the 
[Aptible CLI](https://deploy-docs.aptible.com/docs/cli) in order to set up the
PostgreSQL Database to manage Grafana sessions.

## [`modules/grafana`](./modules/grafana)

This module is responsible for managing the Grafana resources necessary to
visualize and monitor metrics collected by Aptible Metric Drains.
