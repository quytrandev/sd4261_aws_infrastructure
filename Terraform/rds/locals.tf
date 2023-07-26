locals {
    rds = {
        default-db = {
            db_name                 = "testdb"
            db_subnet_group_name    = data.terraform_remote_state.network.outputs.db-subnet-group.name
            vpc_security_group_ids  = [data.terraform_remote_state.network.outputs.security-groups.default-rds]
            allocated_storage       = "20"
            engine                  = "mysql"
            engine_version          = "5.7"
            instance_class          = "db.t3.micro"
            password                = var.default_db_password
        }

        another-db = {
            db_name                 = "testdb2"
            db_subnet_group_name    = data.terraform_remote_state.network.outputs.db-subnet-group.name
            vpc_security_group_ids  = [data.terraform_remote_state.network.outputs.security-groups.default-rds]
            allocated_storage       = "20"
            engine                  = "mysql"
            engine_version          = "5.7"
            instance_class          = "db.t3.micro"
            password                = var.another_db_password
        }
    }
}