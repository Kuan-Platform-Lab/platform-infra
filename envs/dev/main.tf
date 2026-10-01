locals {
  name = "platform-${var.env}"
  azs  = ["${var.region}a", "${var.region}b"]
}

module "network" {
  source = "../../modules/network"
  name   = local.name
  azs    = local.azs
}

module "ecr" {
  source       = "../../modules/ecr"
  repositories = [for a in var.apps : "${var.env}/${a}"]
}

module "secrets" {
  source = "../../modules/secrets"
  name   = local.name
}

module "rds" {
  source             = "../../modules/rds"
  name               = "${local.name}-orders"
  subnet_ids         = module.network.private_subnet_ids
  security_group_ids = [module.network.db_security_group_id]
  db_name            = "orders"
  username           = "orders"
  password           = module.secrets.db_password
}

# Connection details for External Secrets Operator (Phase 2).
resource "aws_secretsmanager_secret_version" "db" {
  secret_id = module.secrets.db_secret_id
  secret_string = jsonencode({
    username = "orders"
    password = module.secrets.db_password
    host     = module.rds.address
    port     = module.rds.port
    dbname   = module.rds.db_name
  })
}

module "eks" {
  source     = "../../modules/eks"
  name       = local.name
  subnet_ids = concat(module.network.public_subnet_ids, module.network.private_subnet_ids)
}
