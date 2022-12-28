variable "domain_name" {
  type = string
  description = "The domain name of the certificate to manage."
}
variable "domain_zone_id" {
  type = string
  description = "The ID of the hosted zone in which to create domain validation records."
}

variable "subject_alternative_names" {
  type = list(string)
  default = []
  description = "The subject alternative names of the certificate to create."
}
variable "subject_alternative_name_zone_id" {
  type = string
  description = "The ID of the hosted zone in which to create subject alternative name validation records."
}
