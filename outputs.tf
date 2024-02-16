output "certificate_arn" {
  description = "The ARN of the managed certificate."
  value = module.certificate.certificate_arn
}

output "domain_validations" {
  description = "A list of the domain validations that have been performed for the managed certificate."
  value = local.domain_validations
}
