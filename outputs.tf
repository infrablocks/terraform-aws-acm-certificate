output "certificate_arn" {
  value = aws_acm_certificate.certificate.arn
}

output "domain_validations" {
  value = local.domain_validations
}
