locals {
  normalized_zone = trim(var.zone_name, ".")
}

resource "aws_route53_zone" "this" {
  count = var.create ? 1 : 0
  name  = local.normalized_zone
  tags  = merge(var.tags, { Name = "${var.name}-zone" })
}

data "aws_route53_zone" "existing" {
  count        = var.create ? 0 : 1
  name         = "${local.normalized_zone}."
  private_zone = false
}