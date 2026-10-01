terraform {
  required_version = ">= 1.9"
  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 6.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

# Point at Floci. For real AWS delete access_key/secret_key, the skip_* flags and the endpoints block.
provider "aws" {
  region     = var.region
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    ec2            = var.floci_endpoint
    ecr            = var.floci_endpoint
    eks            = var.floci_endpoint
    rds            = var.floci_endpoint
    iam            = var.floci_endpoint
    sts            = var.floci_endpoint
    s3             = var.floci_endpoint
    dynamodb       = var.floci_endpoint
    secretsmanager = var.floci_endpoint
    kms            = var.floci_endpoint
    cloudwatchlogs = var.floci_endpoint
  }

  default_tags {
    tags = { Environment = var.env, ManagedBy = "terraform", Project = "platform-lab" }
  }
}
