# module "network_label_staging" {
#   source = "../modules/tags"

#   name        = var.name
#   project     = var.project-name
#   environment = "staging"
#   owner       = var.owner

#   tags = {
#     Description = "Managed by Terraform",
#   }
# }

# module "network_staging" {
#   source = "../modules/network"

#   vpc-cidr-block = var.vpc-cidr-block-staging

#   vpc-endpoint-s3-enable = false
#   create_private_natgw   = true

#   public-subnet-numbers  = var.public-subnet-numbers-staging
#   private-subnet-numbers = var.private-subnet-numbers-staging

#   name        = var.name
#   project     = var.project-name
#   environment = "staging"

#   tags = module.network_label_staging.tags
# }