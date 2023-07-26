locals {
  root_iops            = var.root_volume_type == "io1" ? var.root_iops : 0
  ebs_iops             = var.ebs_volume_type == "io1" ? var.ebs_iops : 0
  ssh_key_pair_path    = var.ssh_key_pair_path == "" ? path.cwd : var.ssh_key_pair_path

  ec2_instances = flatten([
    for value in var.ec2_instances : [
      for replica in range(value.instance-count) : {
        instance = value
      }
    ]
  ])

  ec2_instances_pretty_form = { for index, v in local.ec2_instances : index => v.instance }

  instance_profiles = { for key, v in distinct(local.ec2_instances[*].instance.iam-instance-profile-name) : key => v }

  instance_roles = { for key, v in distinct(local.ec2_instances[*].instance.iam-role-default-name) : key => v }

  ebs_volume_tmp = flatten([
    for index, value in local.ec2_instances : [
      for ebscount in range(value.instance.ebs-volume-count) : {
        az        = value.instance.availability-zone
        ebs-count = value.instance.ebs-volume-count
        ins-count = value.instance.instance-count
        key       = index
        size      = value.instance.ebs-volume-size
      }
    ]
  ])

  ebs_volume = { for index, value in local.ebs_volume_tmp : index => value }
}

module "ebs_volume_tags" {
  source = "../tags"

  name        = var.ebs_volume_name
  project     = var.project
  environment = var.environment
  owner       = var.owner

  tags = {
    Description = "managed by terraform",
  }
}

module "ec2_instance_tags" {
  source = "../tags"

  name        = var.name
  project     = var.project
  environment = var.environment
  owner       = var.owner

  tags = {
    Description = "managed by terraform",
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = "ec2defaultpolicy"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

data "aws_ami" "info" {
  for_each = { for index, v in local.ec2_instances : index => v.instance }
  filter {
    name   = "image-id"
    values = [lookup(each.value, "ami", "ami-03060465516794b47")]
  }

  owners = [lookup(each.value, "ami-owner", "099720109477")]
}

resource "aws_iam_instance_profile" "default" {
  for_each = { for key, v in local.instance_profiles : key => v }
  name     = each.value
  role     = local.instance_roles[each.key]
}

resource "aws_instance" "default" {
  #for_each                    = { for key, v in local.ec2_instances : key => v.instance }
  for_each                    = local.ec2_instances_pretty_form
  ami                         = data.aws_ami.info[each.key].id
  availability_zone           = lookup(each.value, "availability-zone", data.aws_availability_zones.available.names[0])
  instance_type               = lookup(each.value, "instance-type", "t3a.nano")
  ebs_optimized               = lookup(each.value, "ebs-optimized", false)
  disable_api_termination     = lookup(each.value, "disable-api-termination", false)
  user_data                   = lookup(each.value, "user-data", false)
  iam_instance_profile        = one([ for v in local.instance_profiles : v if lookup(each.value, "iam-instance-profile-name", null) == v])
  associate_public_ip_address = lookup(each.value, "associate_public_ip_address", false)
  key_name                    = lookup(each.value, "ssh-key-pair", null) != null && signum(length(lookup(each.value, "ssh-key-pair", ""))) == 1 ? lookup(each.value, "ssh-key-pair", null) : module.ssh_key_pair.key_name
  subnet_id                   = lookup(each.value, "subnet_id", null)
  monitoring                  = lookup(each.value, "monitoring", null)
  private_ip                  = lookup(each.value, "private-ip", null)
  source_dest_check           = lookup(each.value, "source-dest-check", null)
  ipv6_address_count          = var.ipv6_address_count < 0 ? null : var.ipv6_address_count
  ipv6_addresses              = lookup(each.value, "ipv6-addresses", null) != null && length(lookup(each.value, "ipv6-addresses", "")) > 0 ? var.ipv6_addresses : null

  vpc_security_group_ids = lookup(each.value, "security-groups", null)

  root_block_device {
    volume_type           = var.root_volume_type != "" ? var.root_volume_type : data.aws_ami.info[each.key].root_device_type
    volume_size           = lookup(each.value, "root-volume-size", "10")
    iops                  = local.root_iops
    delete_on_termination = var.delete_on_termination
  }

  tags = module.ec2_instance_tags.tags
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  for_each             = { for index, v in local.ec2_instances : index => v.instance }
  security_group_id    = lookup(each.value, "security-group-ids", null)
  network_interface_id = aws_instance.default[each.key].primary_network_interface_id
}

##
## Create keypair if one isn't provided
##

module "ssh_key_pair" {
  source                = "../key_pair"
  environment           = var.environment
  project               = var.project
  name                  = var.name
  ssh_public_key_path   = local.ssh_key_pair_path
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  generate_ssh_key      = var.generate_ssh_key_pair
}

resource "aws_ebs_volume" "default" {
  for_each          = { for index, v in local.ebs_volume : index => v }
  availability_zone = lookup(each.value, "az", data.aws_availability_zones.available.names[0])
  size              = lookup(each.value, "size", 10)
  iops              = local.ebs_iops
  type              = var.ebs_volume_type
  tags              = module.ebs_volume_tags.tags
}

resource "aws_volume_attachment" "default" {
  for_each    = { for index, v in local.ebs_volume : index => v }
  device_name = element(slice(var.ebs_device_names, 0, floor(each.value.ebs-count * each.value.ins-count / max(each.value.ins-count, 1))), each.key)
  volume_id   = aws_ebs_volume.default[each.key].id
  instance_id = aws_instance.default[each.value.key].id
}