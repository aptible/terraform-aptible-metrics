variable "url" {
  type        = string
  description = "The database URL to parse."
}

locals {
  parts = regex(
    "^(?P<scheme>[^:]*)://(?:(?P<user>[^:]+)?(?::(?P<password>[^@]+))?@)?(?P<host>[^:/?#]+)(?::(?P<port>[^/?#]+))?(?:/(?P<database>[^?#]*))?(?:\\?(?P<query>[^#]*))?(?:#(?P<fragment>.*))?$",
    var.url
  )
}

output "scheme" {
  description = "The URL scheme excluding the trailing ://."
  value       = local.parts["scheme"]
}

output "user" {
  value = local.parts["user"]
}

output "password" {
  value     = local.parts["password"]
  sensitive = true
}

output "host" {
  value = local.parts["host"]
}

output "port" {
  value = local.parts["port"]
}

output "database" {
  description = "The URL path without the leading / which corresponds to a database for most database types."
  value       = local.parts["database"]
}

output "query" {
  description = "The URL query string excluding the leading ?."
  value       = local.parts["query"]
}

output "fragment" {
  description = "The URL fragment string excluding the leading #."
  value       = local.parts["fragment"]
}
