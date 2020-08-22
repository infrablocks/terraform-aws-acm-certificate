locals {
  domain_validations = [
    for domain_validation in aws_acm_certificate.certificate.domain_validation_options: {
      record_name: domain_validation.resource_record_name,
      record_type: domain_validation.resource_record_type,
      record_value: domain_validation.resource_record_value,
    }
  ]
}

resource "aws_acm_certificate" "certificate" {
  domain_name = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_validation" {
  for_each = {
    for domain_validation in aws_acm_certificate.certificate.domain_validation_options : domain_validation.domain_name => {
      record_name   = domain_validation.resource_record_name
      record_type   = domain_validation.resource_record_type
      record_value = domain_validation.resource_record_value
    }
  }

  zone_id = var.zone_id
  name = each.value.record_name
  type = each.value.record_type
  ttl = 60
  records = [
    each.value.record_value
  ]
}

resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.domain_validation : record.fqdn]
}
