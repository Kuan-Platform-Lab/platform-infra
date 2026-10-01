# State lives in Floci's S3 + DynamoDB lock (create them first: scripts/bootstrap-backend.sh).
# On real AWS: drop the endpoints/skip_* lines and keep bucket/key/region/dynamodb_table.
terraform {
  backend "s3" {
    bucket         = "tfstate"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tflock"

    endpoints = {
      s3       = "http://localhost:4566"
      dynamodb = "http://localhost:4566"
    }
    access_key                  = "test"
    secret_key                  = "test"
    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}
