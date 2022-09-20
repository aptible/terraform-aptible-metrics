# Aptible Influx Grafana Terraform Module

This terraform module is designed to make it simple to manage metrics collection
and monitoring for Aptible Environments. It includes two submodules:

## `modules/aptible`

This module is responsible for managing the Aptible resources (and the Grafana
data source) necessary to collect and host the metrics.

## `modules/grafana`

This module is responsible for managing the Grafana resources necessary to
visualize and monitor the metrics for the containers in the drained
Environments.
