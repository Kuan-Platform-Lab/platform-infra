terraform {
  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 6.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

variable "name" { type = string }

resource "random_password" "db" {
  length  = 24
  special = false
}

# The secret is created empty-of-host here; the full connection JSON is written
# by the env (aws_secretsmanager_secret_version) once RDS exists.
resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.name}/rds/orders"
  recovery_window_in_days = 0
}

output "db_password" {
  value     = random_password.db.result
  sensitive = true
}
output "db_secret_id" { value = aws_secretsmanager_secret.db.id }
output "db_secret_arn" { value = aws_secretsmanager_secret.db.arn }
