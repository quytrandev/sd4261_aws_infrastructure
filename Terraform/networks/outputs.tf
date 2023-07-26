output "dev-nashtech-devops-vpc" {
  value = module.network_dev.vpc
}

output "db-subnet-group" {
  value = module.network_dev.db-subnet-group
}

output "dev-public-subnet-0" {
  value = module.network_dev.public-subnet-0
}

output "dev-public-subnet-1" {
  value = module.network_dev.public-subnet-1
}

output "dev-public-subnet-2" {
  value = module.network_dev.public-subnet-2
}

output "dev-private-subnet-0" {
  value = module.network_dev.private-subnet-0
}

output "dev-private-subnet-1" {
  value = module.network_dev.private-subnet-1
}

output "dev-private-subnet-2" {
  value = module.network_dev.private-subnet-2
}

output "dev-route-table" {
  value = module.network_dev.route-table
}

output "security-groups" {
  value = module.network_dev.security-group-ids
}

output "security-group-rules-ingress" {
  value = module.network_dev.security-group-rules-ingress-ids
}



################## Staging ############
# output "staging-remediation-vpc" {
#   value = module.network_staging.vpc
# }

# output "staging-public-subnet-0" {
#   value = module.network_staging.public-subnet-0
# }

# output "staging-public-subnet-1" {
#   value = module.network_staging.public-subnet-1
# }

# output "staging-public-subnet-2" {
#   value = module.network_staging.public-subnet-2
# }

# output "staging-private-subnet-0" {
#   value = module.network_staging.private-subnet-0
# }

# output "staging-private-subnet-1" {
#   value = module.network_staging.private-subnet-1
# }

# output "staging-private-subnet-2" {
#   value = module.network_staging.private-subnet-2
# }

# output "staging-route-table" {
#   value = module.network_staging.route-table
# }
