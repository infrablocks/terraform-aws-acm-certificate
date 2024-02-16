locals {
  records = {
    for record in var.records:
        record.domain_name => record
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = local.records

  zone_id = var.zone_id
  name = each.value.resource_record_name
  type = each.value.resource_record_type
  ttl = 60

  records = [
    each.value.resource_record_value
  ]

  allow_overwrite = true
}
