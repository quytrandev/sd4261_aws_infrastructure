locals {
  original_tags    = join(var.delimiter, compact(concat(tolist([var.project, var.environment, var.name]), var.attributes)))
  transformed_tags = var.convert_case ? lower(local.original_tags) : local.original_tags
}

locals {
  id = var.enabled ? local.transformed_tags : ""

  name        = var.enabled ? (var.convert_case ? lower(format("%v", var.name)) : format("%v", var.name)) : ""
  project     = var.enabled ? (var.convert_case ? lower(format("%v", var.project)) : format("%v", var.project)) : ""
  environment = var.enabled ? (var.convert_case ? lower(format("%v", var.environment)) : format("%v", var.environment)) : ""
  owner       = var.enabled ? (var.convert_case ? lower(format("%v", var.owner)) : format("%v", var.owner)) : ""
  delimiter   = var.enabled ? (var.convert_case ? lower(format("%v", var.delimiter)) : format("%v", var.delimiter)) : ""
  attributes  = var.enabled ? (var.convert_case ? lower(format("%v", join(var.delimiter, compact(var.attributes)))) : format("%v", join(var.delimiter, compact(var.attributes)))) : ""

  tags = merge(
    {
      "Name"        = local.id
      "Environment" = local.environment
      "Owner"       = local.owner
      "Project"     = local.project
    },
    var.tags
  )
}
