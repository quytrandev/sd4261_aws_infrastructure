module "bastion-host" {
  source = "../modules/ec2"
  name                          = "Bastion-host"

  ec2_instances                 = local.bastion_hosts
  generate_ssh_key_pair         = true
  owner                         = var.owner
  project                       = var.project
  environment                   = var.environment
}