variable "url" {
  type        = string
  description = "The database URL to parse."
}

locals {
  parts = regex(
    "^(?P<scheme>[^:]*)://(?:(?P<user>[^:]+)?(?::(?P<password>[^@]+))?@)?(?P<host>[^:/?#]+)(?::(?P<port>[^/?#]+))?(?:/(?P<database>[^?#]*))?(?:\\?(?P<query>[^#]*))?(?:#(?P<hash>.*))?$",
    var.url
  )
}

output "scheme" {
  value       = local.parts["scheme"]
  description = "The URL scheme excluding the trailing ://."
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
  value       = local.parts["database"]
  description = "The URL path which corresponds to a database for most database types."
}

output "query" {
  value       = local.parts["query"]
  description = "The URL query string excluding the leading ?."
}

output "hash" {
  value       = local.parts["hash"]
  description = "The URL hash string excluding the leading #."
}
