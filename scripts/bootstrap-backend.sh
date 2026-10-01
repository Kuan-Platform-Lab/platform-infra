#!/usr/bin/env bash
# Create the Terraform state bucket + lock table in Floci (idempotent).
set -euo pipefail
export AWS_ENDPOINT_URL=${AWS_ENDPOINT_URL:-http://localhost:4566}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-test} AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-test}

aws s3api head-bucket --bucket tfstate 2>/dev/null || aws s3api create-bucket --bucket tfstate >/dev/null
aws s3api put-bucket-versioning --bucket tfstate --versioning-configuration Status=Enabled
aws dynamodb describe-table --table-name tflock >/dev/null 2>&1 || aws dynamodb create-table \
  --table-name tflock --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST >/dev/null
echo "backend ready: s3://tfstate + dynamodb:tflock"
