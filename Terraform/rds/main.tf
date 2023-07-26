module "rds" {
    source = "../modules/rds"

    rds             = local.rds

    name            = "rds-${var.project}-${var.environment}"
    owner           = var.owner
    project         = var.project
    environment     = var.environment
}