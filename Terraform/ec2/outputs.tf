# output "public_dns" {
#   value = module.bastion-host.public_dns
# }

# output "public_ip" {
#   value = module.bastion-host.public_ip
# }

# output "private_dns" {
#   value = module.bastion-host.private_dns
# }

# output "arn" {
#   value = module.bastion-host.arn
# }

# output "instance-inputs" {
#   value = module.bastion-host.instance-inputs
# }

# output "ec2-instances" {
#   value = module.bastion-host.ec2-instances
# }

output "all" {
  value = module.bastion-host
}