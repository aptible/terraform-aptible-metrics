# Aptible Influx Grafana Terraform Module

This terraform module is designed to make it simple to manage "self-hosted"
metrics collection and monitoring for Aptible Environments on Aptible. It
includes two submodules to manage resources:

## `modules/aptible`

This module is responsible for managing the Aptible resources (and the Grafana
data source) necessary to collect and host metrics. This module likely won't be
used directly unless Grafana dashboards are being managed elsewhere.

## `modules/grafana`

This module is responsible for managing the Grafana resources necessary to
visualize and monitor the collected metrics. This module is useful on its own
for applying the Grafana dashboards and alert rules to an existing Grafana
instance. The module creates its own folder for the resources it manages so as
to not interfere with other resources.
