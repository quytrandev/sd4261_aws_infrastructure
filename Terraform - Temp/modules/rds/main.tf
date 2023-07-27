module "db_tags" {
  source = "../tags"

  project     = var.project
  environment = var.environment
  owner       = var.owner

  tags = {
    Description = "managed by terraform",
  }
}

resource "aws_db_instance" "default" {
  for_each                    = var.rds
  identifier                  = each.key
  allocated_storage           = lookup(each.value, "allocated_storage", 10)
  db_name                     = lookup(each.value, "db_name", "${var.name}-${var.project}")
  db_subnet_group_name        = lookup(each.value, "db_subnet_group_name", null)
  vpc_security_group_ids      = lookup(each.value, "vpc_security_group_ids", null)
  engine                      = lookup(each.value, "engine", "mysql")
  engine_version              = lookup(each.value, "engine_version", "5.7")
  instance_class              = lookup(each.value, "instance_class", "db.t3.micro")
  username                    = lookup(each.value, "username", "nashtechdevops")
  publicly_accessible         = lookup(each.value, "publicly_accessible", null)
  password                    = lookup(each.value, "password", null)
  parameter_group_name        = lookup(each.value, "parameter_group_name", null)
  skip_final_snapshot         = true
  multi_az                    = false
  delete_automated_backups    = true

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }

  tags = merge(
     module.db_tags.tags,
    {
      Name = each.key
    }
   )
}

