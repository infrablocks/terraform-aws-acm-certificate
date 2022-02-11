terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
      configuration_aliases = [
        aws.certificate,
        aws.domain_validation,
        aws.san_validation
      ]
    }
  }
}