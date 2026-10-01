output "vpc_id" { value = module.network.vpc_id }
output "ecr_repository_urls" { value = module.ecr.repository_urls }
output "rds_address" { value = module.rds.address }
output "rds_port" { value = module.rds.port }
output "db_secret_arn" { value = module.secrets.db_secret_arn }
output "eks_cluster_name" { value = module.eks.cluster_name }
output "eks_endpoint" { value = module.eks.endpoint }
