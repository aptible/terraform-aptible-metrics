# ------------------------------------------------------------------------------
# The simplest usage is to specify the metrics_environment. This configuration
# will host metrics on my-env and will also collect metrics from my-env.
# ------------------------------------------------------------------------------
module "aptible_metrics" {
  # Use the git source in your own templates
  # source = "git::git@github.com:aptible/terraform-aptible-metrics.git?ref=v0.1.0"
  source              = "../../"
  metrics_environment = "my-env"
}
