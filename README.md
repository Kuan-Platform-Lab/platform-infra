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

## Phase 1: Terraform trên Floci

```bash
cd platform-infra/local && docker compose up -d floci      # Floci (đã map cổng RDS 7001-7099)
./scripts/bootstrap-backend.sh                              # bucket tfstate + bảng tflock
cd envs/dev && terraform init && terraform apply

# kubectl: EKS của Floci không nhận key test/test, cần IAM access key thật
aws iam create-user --user-name lab-admin
aws iam create-access-key --user-name lab-admin             # export AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY
aws eks update-kubeconfig --name platform-dev && kubectl get nodes
```

`envs/dev` tạo: VPC (2 public + 2 private subnet), 2 repo ECR (`dev/<app>`, tag immutable), secret mật khẩu DB (Secrets Manager),
RDS PostgreSQL, EKS (k3s). Mỗi env một state (`envs/<env>/terraform.tfstate`). `envs/prod` cùng cấu trúc, chưa apply
(Floci chỉ có một account/region; chạy hai cluster cùng lúc rất tốn RAM).

Chuyển sang AWS thật: bỏ `access_key/secret_key`, các cờ `skip_*` và khối `endpoints` trong `providers.tf` / `backend.tf`.

Lưu ý khi chạy trên Floci: k3s luôn chạy phiên bản của Floci (không theo `kubernetes_version`), RDS trả địa chỉ container
nội bộ (kết nối từ host qua `localhost:<rds_port>`), không có NAT gateway.
