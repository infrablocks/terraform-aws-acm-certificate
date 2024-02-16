output "certificate_arn" {
  description = "The ARN of the managed certificate."
  value = aws_acm_certificate.certificate.arn
}

output "domain_validation_options" {
  description = "A list of domain validation options that need to be performed to validate the managed certificate."
  value = aws_acm_certificate.certificate.domain_validation_options
}
