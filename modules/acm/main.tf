resource "aws_acm_certificate" "this" {
  provider                  = aws
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.include_www ? ["www.${var.domain_name}"] : []
  tags                      = merge(var.tags, { Name = "${var.name}-acm" })
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "this" {
  provider                = aws
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.validation : r.fqdn]
}