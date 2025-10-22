locals {
  name_prefix = "${var.project}-${var.environment}"
  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "network" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_cidr
  az_count = var.az_count
  tags     = local.tags
  name     = local.name_prefix
}

module "route53" {
  count     = var.domain_zone_name != null ? 1 : 0
  source    = "./modules/route53"
  name      = local.name_prefix
  create    = var.create_hosted_zone # <- Debe existir variable "create" en el módulo
  zone_name = var.domain_zone_name
  tags      = local.tags
}

locals {

  effective_hosted_zone_id = coalesce(
    var.hosted_zone_id,
    try(module.route53[0].zone_id, null)
  )
}

module "acm" {
  count          = var.create_acm && var.domain_name != null && local.effective_hosted_zone_id != null ? 1 : 0
  source         = "./modules/acm"
  providers      = { aws = aws.us_east_1 } # CloudFront exige ACM en us-east-1
  name           = local.name_prefix
  domain_name    = var.domain_name
  hosted_zone_id = local.effective_hosted_zone_id
  include_www    = var.include_www
  tags           = local.tags
}

locals {
  cloudfront_cert_arn = var.create_acm ? module.acm[0].certificate_arn : var.acm_certificate_arn
}

module "s3_cloudfront" {
  source              = "./modules/s3_cloudfront"
  name                = local.name_prefix
  acm_certificate_arn = local.cloudfront_cert_arn
  domain_name         = var.domain_name
  tags                = local.tags
}

module "lambda_api" {
  source                = "./modules/lambda_api"
  name                  = local.name_prefix
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  lambda_code_bucket    = var.lambda_code_bucket
  lambda_code_key       = var.lambda_code_key
  lambda_runtime        = var.lambda_runtime
  lambda_handler        = var.lambda_handler
  rds_secret_arn        = module.rds_aurora.db_secret_arn
  rds_security_group_id = module.rds_aurora.db_sg_id
  tags                  = local.tags
  depends_on            = [module.s3_cloudfront]
}

module "rds_aurora" {
  source             = "./modules/rds_aurora"
  name               = local.name_prefix
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  engine             = var.db_engine
  engine_version     = var.db_engine_version
  db_name            = var.db_name
  username           = var.db_username
  min_capacity       = var.db_min_capacity
  max_capacity       = var.db_max_capacity
  lambda_sg_id       = module.lambda_api.lambda_sg_id
  tags               = local.tags
}

module "observability" {
  source      = "./modules/observability"
  name        = local.name_prefix
  api_id      = module.lambda_api.api_id
  alarm_email = var.alarm_email
  tags        = local.tags
}
