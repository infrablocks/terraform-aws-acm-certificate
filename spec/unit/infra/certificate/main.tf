data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "certificate" {
  source = "../../../../modules/certificate"

  domain_name = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  wait_for_validation = var.wait_for_validation
}
