# output "public_dns" {
#   value = aws_instance.default[0].public_dns
# }

# output "public_ip" {
#   value = aws_instance.default[0].public_ip
# }

# output "private_dns" {
#   value = aws_instance.default[0].private_dns
# }

output "ec2_instances" {
  value = { for index, v in aws_instance.default : "${v.tags_all.Name}-${index}" => v.private_dns }
}

output "instance_inputs" {
  #value = { for index, v in local.ec2-instances : index => v.instance }
  value = local.ec2_instances_pretty_form
}

output "instance_profiles" {
  value = local.instance_profiles
}

output "instance_roles" {
  value = local.instance_roles
}

output "ebscount_tmp" {
  value = local.ebs_volume_tmp
}

output "ebscount" {
  value = local.ebs_volume
}

output "instance_inputs_raw" {
  value = local.ec2_instances
}

