data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "acm_certificate" {
  source = "../../../.."

  domain_name = var.domain_name
  domain_zone_id = var.zone_id
  subject_alternative_names = var.subject_alternative_names
  subject_alternative_name_zone_id = var.zone_id

  providers = {
    aws.certificate: aws
    aws.domain_validation: aws
    aws.san_validation: aws
  }
}
