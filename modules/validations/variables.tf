variable "zone_id" {
  type = string
  description = "The ID of the zone in which to create the specified validation records."
}

variable "records" {
  type = list(object({
    domain_name: string
    resource_record_name: string
    resource_record_type: string
    resource_record_value: string
  }))
}
