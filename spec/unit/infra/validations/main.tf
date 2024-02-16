data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "validations" {
  source = "../../../../modules/validations"

  zone_id = var.zone_id
  records = var.records
}
