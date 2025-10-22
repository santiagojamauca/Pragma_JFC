output "cloudfront_domain_name" {
  value = module.s3_cloudfront.cloudfront_domain_name
}

output "api_base_url" {
  value = module.lambda_api.api_base_url
}

output "rds_cluster_arn" {
  value = module.rds_aurora.cluster_arn
}