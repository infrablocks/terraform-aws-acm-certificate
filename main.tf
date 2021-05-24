locals {
  domain_validations = [
    for domain_validation in aws_acm_certificate.certificate.domain_validation_options: {
      record_name: domain_validation.resource_record_name,
      record_type: domain_validation.resource_record_type,
      record_value: domain_validation.resource_record_value,
    }
  ]
  domain_validation_records = {
    for domain_validation in aws_acm_certificate.certificate.domain_validation_options:
      domain_validation.domain_name => {
        record_name: domain_validation.resource_record_name,
        record_type: domain_validation.resource_record_type,
        record_value: domain_validation.resource_record_value,
      }
    if domain_validation.domain_name == var.domain_name
  }
  subject_alternative_name_validation_records = {
    for domain_validation in aws_acm_certificate.certificate.domain_validation_options:
      domain_validation.domain_name => {
        record_name: domain_validation.resource_record_name,
        record_type: domain_validation.resource_record_type,
        record_value: domain_validation.resource_record_value,
      }
    if contains(var.subject_alternative_names, domain_validation.domain_name)
  }
}

resource "aws_acm_certificate" "certificate" {
  provider = aws.certificate

  domain_name = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_validation" {
  provider = aws.domain_validation

  for_each = local.domain_validation_records

  zone_id = var.domain_zone_id
  name = each.value.record_name
  type = each.value.record_type
  ttl = 60
  records = [
    each.value.record_value
  ]

  allow_overwrite = true

  depends_on = [
    aws_acm_certificate.certificate
  ]
}

resource "aws_route53_record" "subject_alternative_name_validation" {
  provider = aws.san_validation

  for_each = local.subject_alternative_name_validation_records

  zone_id = var.subject_alternative_name_zone_id
  name = each.value.record_name
  type = each.value.record_type
  ttl = 60
  records = [
    each.value.record_value
  ]

  allow_overwrite = true

  depends_on = [
    aws_acm_certificate.certificate
  ]
}

resource "aws_acm_certificate_validation" "validation" {
  provider = aws.certificate
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = concat([for record in aws_route53_record.domain_validation : record.fqdn], [for record in aws_route53_record.subject_alternative_name_validation : record.fqdn])
}
