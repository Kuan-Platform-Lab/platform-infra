variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "floci_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

variable "apps" {
  description = "One ECR repo per app"
  type        = list(string)
  default     = ["order-service", "payment-service"]
}
