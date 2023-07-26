module "tags_dev" {
  source = "../modules/tags"

  name        = var.name
  project     = var.project-name
  environment = var.environment
  owner       = var.owner

  tags = {
    Description = "Managed by Terraform",
  }
}
