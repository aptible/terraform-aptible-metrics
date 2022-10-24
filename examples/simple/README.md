# Collecting Metrics from a Single Environment

The simplest usage is to specify the `metrics_environment`. This configuration
will host metrics on `my-env` and will also collect metrics from `my-env`.

```hcl
module "aptible_metrics" {
  source              = "../../"
  metrics_environment = "my-env"
}
```
