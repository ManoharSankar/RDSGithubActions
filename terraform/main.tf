provider "aws"{
    region = var.aws_region
}

data "aws_secretsmanager_secret" "db"{
    name = var.secret_name
}

data "aws_secretmanager_secret_version" "db"{
    secret_id = data.aws_secretmanager_secret.db.id

}

locals {
    db_creds = jsondecode(
        data.aws_secretsmanager_secret_version.db.secret_string
    )
}

resource "aws_db_instance" "postgres" {
    identifier = "postgres_db"
    engine = "postgres"
    engine_version = "15.4"
    instance_class = "db.t3.micro"
    allocated_storage = 20

    db_name = "appdb"
    username = local.db_creds.username
    password = local.db_creds.password

    skip_final_snapshot = true
    publicly_accessible = false
    multi_az = false

    storage_encrypted = true
    backup_retention_period = 7

    tags = {
        Name = "postgres-rds"
    }
}