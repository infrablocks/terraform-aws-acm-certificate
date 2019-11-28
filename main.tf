resource "aws_acm_certificate" "certificate" {
  domain_name = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_validation" {
  count = length(distinct(concat([var.domain_name], var.subject_alternative_names)))

  zone_id = var.zone_id
  name = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_name
  type = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_type
  ttl = 60

  records = [
    aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_value
  ]
}

resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = aws_route53_record.domain_validation[*].fqdn
}

locals {
  domain_validations = [
    for domain_validation in aws_acm_certificate.certificate.domain_validation_options:
      {
        record_name: domain_validation.resource_record_name,
        record_type: domain_validation.resource_record_type,
        record_value: domain_validation.resource_record_value,
      }
  ]
}
