locals {
  cloudfront_zone_id = "Z2FDTNDATAQYW2"
}

data "aws_cloudfront_distribution" "frontend" {
  id = module.s3_cloudfront.distribution_id
}

resource "aws_route53_record" "app_a" {
  count   = var.domain_name != null && local.effective_hosted_zone_id != null ? 1 : 0
  zone_id = local.effective_hosted_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = data.aws_cloudfront_distribution.frontend.domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "app_aaaa" {
  count   = var.domain_name != null && local.effective_hosted_zone_id != null ? 1 : 0
  zone_id = local.effective_hosted_zone_id
  name    = var.domain_name
  type    = "AAAA"
  alias {
    name                   = data.aws_cloudfront_distribution.frontend.domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_a" {
  count   = var.include_www && var.domain_name != null && local.effective_hosted_zone_id != null ? 1 : 0
  zone_id = local.effective_hosted_zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  alias {
    name                   = data.aws_cloudfront_distribution.frontend.domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_aaaa" {
  count   = var.include_www && var.domain_name != null && local.effective_hosted_zone_id != null ? 1 : 0
  zone_id = local.effective_hosted_zone_id
  name    = "www.${var.domain_name}"
  type    = "AAAA"
  alias {
    name                   = data.aws_cloudfront_distribution.frontend.domain_name
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}