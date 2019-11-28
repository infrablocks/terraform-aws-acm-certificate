output "certificate_arn" {
  value = module.acm_certificate.certificate_arn
}

output "domain_validations" {
  value = module.acm_certificate.domain_validations
}
