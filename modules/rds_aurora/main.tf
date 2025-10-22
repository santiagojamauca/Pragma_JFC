resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnets"
  subnet_ids = var.private_subnet_ids
  tags       = merge(var.tags, { Name = "${var.name}-db-subnets" })
}

resource "aws_security_group" "db" {
  name        = "${var.name}-db-sg"
  description = "Aurora access"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Lambda to DB"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.lambda_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-db-sg" })
}

resource "aws_secretsmanager_secret" "db" {
  name = "${var.name}/db"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_v" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({ username = var.username, password = random_password.this.result, dbname = var.db_name })
}

resource "random_password" "this" {
  length  = 20
  special = true
}

resource "aws_rds_cluster" "this" {
  engine                          = var.engine
  engine_mode                     = "provisioned"
  engine_version                  = var.engine_version
  database_name                   = var.db_name
  master_username                 = var.username
  master_password                 = random_password.this.result
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.db.id]
  storage_encrypted               = true
  backup_retention_period         = 7
  deletion_protection             = false
  preferred_backup_window         = "02:00-03:00"
  preferred_maintenance_window    = "sun:03:00-sun:04:00"
  copy_tags_to_snapshot           = true
  tags                            = var.tags

  serverlessv2_scaling_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }
}

resource "aws_rds_cluster_instance" "serverless_v2" {
  identifier         = "${var.name}-db-1"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = var.engine
  engine_version     = var.engine_version

  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = var.tags
}

resource "aws_rds_cluster_parameter_group" "this" {
  name   = "${var.name}-pg"
  family = var.engine == "aurora-postgresql" ? "aurora-postgresql${var.engine_version}" : "aurora-mysql${var.engine_version}"
  tags   = var.tags
}
