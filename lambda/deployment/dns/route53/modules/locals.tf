locals {
  # Module identifier
  dns_module_name = "dns/route53"

  # ALB -> A alias record
  # alb_* locals are provided by networking/alb/modules/locals.tf when composed,
  # or by dns/route53/stubs_no_alb/alb_stubs.tf when not composed.
  dns_alb_dns_name = local.alb_dns_name
  dns_alb_zone_id  = local.alb_zone_id

  # Cross-module outputs
  dns_record_name = var.dns_full_domain
}
