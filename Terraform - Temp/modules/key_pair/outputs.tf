output "key_name" {
  value = compact(concat(
    aws_key_pair.imported.*.key_name,
    aws_key_pair.generated.*.key_name
  ))[0]

  description = "Name of SSH key"
}