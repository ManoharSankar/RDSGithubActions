provider "aws" {
  region = var.aws_region
}

# Get secret metadata
data "aws_secretsmanager_secret" "db" {
  name = var.secret_name
}

# Get latest secret value
data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.db.id
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.db.secret_string
  )
}

resource "aws_db_instance" "postgres" {
  identifier = "postgres-db"

  engine         = "postgres"
  engine_version = "15"

  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "appdb"
  username = local.db_creds.username
  password = local.db_creds.password

  skip_final_snapshot = true
  publicly_accessible = false
  storage_encrypted   = true

  tags = {
    Name = "postgres-rds"
  }
}
