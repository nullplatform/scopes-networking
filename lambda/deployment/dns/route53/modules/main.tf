
# DNS A alias record for ALB (private/internal scopes)
# Triggered by the ALB module's cross-module local alb_dns_name (non-empty when ALB is composed).
resource "aws_route53_record" "alb" {
  count = local.dns_alb_dns_name != "" ? 1 : 0

  zone_id = var.dns_hosted_zone_id
  name    = var.dns_full_domain
  type    = "A"

  alias {
    name                   = local.dns_alb_dns_name != "" ? local.dns_alb_dns_name : "placeholder.invalid"
    zone_id                = local.dns_alb_zone_id != "" ? local.dns_alb_zone_id : "Z1D633PJN98FT9"
    evaluate_target_health = true
  }
}
