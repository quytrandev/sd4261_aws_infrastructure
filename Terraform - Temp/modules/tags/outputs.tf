output "id" {
  value       = local.id
  description = "Disambiguated ID"
}

output "name" {
  value       = local.name
  description = "Normalized name"
}

output "project" {
  value       = local.project
  description = "Normalized project"
}

output "environment" {
  value       = local.environment
  description = "Normalized stage"
}

output "owner" {
  value       = local.owner
  description = "Normalize owner"
}
output "delimiter" {
  value       = local.delimiter
  description = "Delimiter between `namespace`, `stage`, `name` and `attributes`"
}

output "attributes" {
  value       = local.attributes
  description = "Normalized attributes"
}

output "tags" {
  value       = local.tags
  description = "Normalized Tag map"
}
