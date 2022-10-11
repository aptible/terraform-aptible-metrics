# ------------------------------------------------------------------------------
# Collecting metrics for multiple Environments is also a simple task. This
# configuration will host the metrics in the my-metrics Environment and will
# collect metrics from my-metrics, my-env, and my-other-env Environments.
# ------------------------------------------------------------------------------
module "aptible_metrics" {
  # Use the git source in your own templates
  # source = "git::git@github.com:aptible/terraform-aptible-metrics.git?ref=v0.1.0"
  source              = "../../"
  metrics_environment = "my-metrics"
  drain_environments  = ["my-metrics", "my-env", "my-other-env"]
}
