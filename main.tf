locals {
  domain_validations = [
    for domain_validation in aws_acm_certificate.certificate.domain_validation_options: {
      record_name: domain_validation.resource_record_name,
      record_type: domain_validation.resource_record_type,
      record_value: domain_validation.resource_record_value,
    }
  ]
  domain_validation_records = [
    for key, value in aws_acm_certificate.certificate.domain_validation_options : tomap(value)
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
  count = length(var.subject_alternative_names) + 1

  zone_id = var.zone_id
  name = element(local.domain_validation_records, count.index).resource_record_name
  type = element(local.domain_validation_records, count.index).resource_record_type
  ttl = 60
  records = [
    element(local.domain_validation_records, count.index).resource_record_value
  ]

  allow_overwrite = true

  depends_on = [
    aws_acm_certificate.certificate
  ]
}

resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.domain_validation : record.fqdn]
}
