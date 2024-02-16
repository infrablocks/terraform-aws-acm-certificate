locals {
  domain_validations = [
    for domain_validation in module.certificate.domain_validation_options: {
      record_name: domain_validation.resource_record_name,
      record_type: domain_validation.resource_record_type,
      record_value: domain_validation.resource_record_value,
    }
  ]
  domain_validation_records = [
    for domain_validation in module.certificate.domain_validation_options:
      domain_validation if domain_validation.domain_name == var.domain_name
  ]
  subject_alternative_name_validation_records = [
    for domain_validation in module.certificate.domain_validation_options:
      domain_validation if contains(
        var.subject_alternative_names, domain_validation.domain_name
      )
  ]
}

module "certificate" {
  source = "./modules/certificate"

  domain_name = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  providers = {
    aws = aws.certificate
  }
}

module "domain_validations" {
  source = "./modules/validations"

  zone_id = var.domain_zone_id
  records = local.domain_validation_records

  providers = {
    aws = aws.domain_validation
  }
}

module "subject_alternative_name_validations" {
  source = "./modules/validations"

  zone_id = var.subject_alternative_name_zone_id
  records = local.subject_alternative_name_validation_records

  providers = {
    aws = aws.san_validation
  }
}

moved {
  from = aws_acm_certificate.certificate
  to = module.certificate.aws_acm_certificate.certificate
}

moved {
  from = aws_acm_certificate_validation.validation
  to = module.certificate.aws_acm_certificate_validation.validation
}

moved {
  from = aws_route53_record.domain_validation
  to = module.domain_validations.aws_route53_record.certificate_validation
}

moved {
  from = aws_route53_record.subject_alternative_name_validation
  to = module.subject_alternative_name_validations.aws_route53_record.certificate_validation
}
