module "network_label_dev" {
  source = "../modules/tags"

  name        = var.name
  project     = var.project-name
  environment = "dev"
  owner       = var.owner

  tags = {
    Description = "Managed by Terraform",
  }
}

module "network_dev" {
  source = "../modules/network"

  vpc-cidr-block = var.vpc-cidr-block-dev

  vpc-endpoint-s3-enable = false
  create_private_natgw   = true

  public-subnet-numbers  = var.public-subnet-numbers-dev
  private-subnet-numbers = var.private-subnet-numbers-dev

  security-groups = local.security-groups

  name        = var.name
  project     = var.project-name
  environment = "dev"

  tags = module.network_label_dev.tags
}