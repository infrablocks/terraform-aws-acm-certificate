output "certificate_arn" {
  value = module.certificate.certificate_arn
}

output "domain_validation_options" {
  value = module.certificate.domain_validation_options
}
