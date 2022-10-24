module "aptible_metrics" {
  # Use the git or terraform registry source in your own templates
  # source = "git::git@github.com:aptible/terraform-aptible-metrics.git?ref=v1.0.0"
  source              = "../../"
  metrics_environment = "my-metrics"
  drain_environments  = ["my-metrics", "my-env", "my-other-env"]
}
