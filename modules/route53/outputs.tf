output "zone_id" {
  value = var.create ? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.existing[0].zone_id
}
output "name_servers" {
  value = var.create ? aws_route53_zone.this[0].name_servers : try(data.aws_route53_zone.existing[0].name_servers, [])
}