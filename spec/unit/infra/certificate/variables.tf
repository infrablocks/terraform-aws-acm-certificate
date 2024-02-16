variable "region" {}

variable "domain_name" {}
variable "subject_alternative_names" {
  type = list(string)
}

variable "wait_for_validation" {
  type = bool
  default = null
}
