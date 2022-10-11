# Aptible Metrics Terraform Module

This terraform module is designed to make it simple to manage "self-hosted"
metrics collection and monitoring for Aptible Environments on Aptible. It
includes two submodules for managing resources:

## `modules/aptible`

This module is responsible for managing the Aptible resources (and the Grafana
data source) necessary to collect and store metrics. This module likely won't be
used directly unless Grafana dashboards are being managed elsewhere.

### Dependencies

This module depends on the 
[Aptible CLI](https://deploy-docs.aptible.com/docs/cli) in order to set up the
postgres Database to manage grafana sessions.

## `modules/grafana`

This module is responsible for managing the Grafana resources necessary to
visualize and monitor the collected metrics. This module is useful on its own
for applying the Grafana dashboards and alert rules to an existing Grafana
instance. The module creates its own folder for the resources it manages so as
to not interfere with other resources.
