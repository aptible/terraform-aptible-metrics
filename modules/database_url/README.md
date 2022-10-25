<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_url"></a> [url](#input\_url) | The database URL to parse. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database"></a> [database](#output\_database) | The URL path without the leading / which corresponds to a database for most database types. |
| <a name="output_fragment"></a> [fragment](#output\_fragment) | The URL fragment string excluding the leading #. |
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_password"></a> [password](#output\_password) | n/a |
| <a name="output_port"></a> [port](#output\_port) | n/a |
| <a name="output_query"></a> [query](#output\_query) | The URL query string excluding the leading ?. |
| <a name="output_scheme"></a> [scheme](#output\_scheme) | The URL scheme excluding the trailing ://. |
| <a name="output_user"></a> [user](#output\_user) | n/a |
<!-- END_TF_DOCS -->