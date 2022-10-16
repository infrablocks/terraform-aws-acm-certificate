variable "region" {}

variable "domain_name" {}
variable "subject_alternative_names" {
  type = list(string)
}

variable "zone_id" {}
