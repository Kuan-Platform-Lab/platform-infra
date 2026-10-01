# platform-infra

Terraform: hạ tầng (network, eks, rds, ecr, secrets). Mỗi env một state riêng. Phase 1.

Xem Guide.md (Platform Engineering Lab) để biết bối cảnh.

## Phase 0: chạy local

Clone `platform-infra`, `order-service`, `payment-service` cạnh nhau, rồi:

```bash
cd platform-infra/local && docker compose up -d --build
export AWS_ENDPOINT_URL=http://localhost:4566 AWS_DEFAULT_REGION=us-east-1 AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test
aws s3 ls
curl -XPOST localhost:8080/orders -H 'content-type: application/json' -d '{"customerId":"c1","amount":100}'
```

order-service: app `:8080`, health/metrics `:8081`. payment-service: app `:8082`, health/metrics `:8083`.
