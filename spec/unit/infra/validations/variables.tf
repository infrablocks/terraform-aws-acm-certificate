variable "region" {}

variable "zone_id" {}
variable "records" {
  type = list(object({
    domain_name: string
    resource_record_name: string
    resource_record_type: string
    resource_record_value: string
  }))
}
