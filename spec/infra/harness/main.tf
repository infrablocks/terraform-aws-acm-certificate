data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "acm_certificate" {
  source = "../../../../"

  domain_name = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  zone_id = var.zone_id
}
