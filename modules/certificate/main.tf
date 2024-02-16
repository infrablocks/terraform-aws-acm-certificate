locals {
  domain_validation_fqdns = [
    for domain_validation_options in aws_acm_certificate.certificate.domain_validation_options:
      replace(domain_validation_options.resource_record_name, "/\\.$/", "")
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

resource "aws_acm_certificate_validation" "validation" {
  count = var.wait_for_validation ? 1 : 0

  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = local.domain_validation_fqdns
}
