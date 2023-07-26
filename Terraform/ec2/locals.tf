locals {
  bastion_hosts = {
    bastion_host_1 = {
        name = "bastion-host"
        ami                           = "ami-0b13630a979679b27"
        ami-owner                     = "099720109477" // Amazon is the owner
        instance-type                 = "t3a.micro"
        root-volume-size              = 10
        vpc-id                        = data.terraform_remote_state.network.outputs.dev-nashtech-devops-vpc.id
        security-group-ids            = data.terraform_remote_state.network.outputs.security-groups.bastion-host
        ebs-volume-count              = 0 // increase this value if you want to add more disk
        ebs-volume-size               = 20
        create-default-security-group = true
        generate-ssh-key-pair         = true
        ssh-key-pair-path             = "./"
        associate_public_ip_address   = true
        subnet_id                     = data.terraform_remote_state.network.outputs.dev-public-subnet-0.id
        availability-zone             = data.terraform_remote_state.network.outputs.dev-public-subnet-0.availability_zone
        instance-count                = 2
        iam-role-default-name         = data.terraform_remote_state.bootstrap.outputs.bastion_role_name
        iam-instance-profile-name     = "bastion-host-1-profile"
        ebs-volume-name               = "volume of the Bastion host"
    }

  bastion_host_2 = {
        name = "bastion-host-2"
        ami                           = "ami-0b13630a979679b27"
        ami-owner                     = "099720109477" // Amazon is the owner
        instance-type                 = "t3a.micro"
        root-volume-size              = 10
        vpc-id                        = data.terraform_remote_state.network.outputs.dev-nashtech-devops-vpc.id
        security-group-ids            = data.terraform_remote_state.network.outputs.security-groups.bastion-host
        ebs-volume-count              = 2 // increase this value if you want to add more disk
        ebs-volume-size               = 20
        associate_public_ip_address   = true
        create-default-security-group = true
        generate-ssh-key-pair         = true
        ssh-key-pair-path             = "./"
        subnet_id                     = data.terraform_remote_state.network.outputs.dev-public-subnet-1.id
        availability-zone             = data.terraform_remote_state.network.outputs.dev-public-subnet-1.availability_zone
        instance-count                = 2
        iam-role-default-name         = "bastion-nashtech-devops-0002"
        iam-instance-profile-name     = "bastion-host-2-profile"
        ebs-volume-name               = "volume of the Bastion host"
    }
  }
}   