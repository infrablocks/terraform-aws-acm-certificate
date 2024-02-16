variable "domain_name" {
  type = string
  description = "The domain name of the certificate to manage."
}

variable "subject_alternative_names" {
  type = list(string)
  default = []
  description = "The subject alternative names of the certificate to create."
}

variable "wait_for_validation" {
  type = bool
  default = true
  nullable = false
  description = "Whether to wait for certificate validation to complete before considering the module application complete."
}
