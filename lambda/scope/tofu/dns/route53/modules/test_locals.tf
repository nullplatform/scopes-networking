# NOTE: Files matching test_*.tf are skipped by compose_modules
# These variables simulate cross-module locals for isolated testing

variable "test_alb_dns_name" {
  description = "Test-only: Simulates ALB module output"
  default     = ""
}

variable "test_alb_zone_id" {
  description = "Test-only: Simulates ALB module output"
  default     = ""
}

locals {
  alb_dns_name = var.test_alb_dns_name
  alb_zone_id  = var.test_alb_zone_id
}
