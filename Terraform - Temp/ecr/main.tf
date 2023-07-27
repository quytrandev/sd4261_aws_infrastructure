module "ecr" {
  source      = "../modules/ecr"
  name        = "ecr"
  project     = "quytran-practical-devops-pj"
  environment = "mgmt"
  owner       = "quytrandev"
}
