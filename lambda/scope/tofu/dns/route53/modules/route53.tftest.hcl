mock_provider "aws" {}

variables {
  dns_hosted_zone_id     = "Z1234567890ABC"
  dns_domain             = "example.com"
  dns_subdomain          = "api"
  dns_full_domain        = "api.example.com"
  dns_resource_tags_json = {}
}

# --- ALB mode (alias record) ---

run "creates_alias_record_for_alb" {
  variables {
    test_alb_dns_name = "my-alb-1234.us-east-1.elb.amazonaws.com"
    test_alb_zone_id  = "Z35SXDOTRQ7X7K"
  }
  command = plan

  assert {
    condition     = length(aws_route53_record.alb) == 1
    error_message = "ALB alias record should be created"
  }

  assert {
    condition     = aws_route53_record.alb[0].name == "api.example.com"
    error_message = "Record name should be the full domain"
  }

  assert {
    condition     = aws_route53_record.alb[0].type == "A"
    error_message = "Record type should be A for alias"
  }

  assert {
    condition     = aws_route53_record.alb[0].zone_id == "Z1234567890ABC"
    error_message = "Zone ID should match"
  }
}

run "configures_alias_target_for_alb" {
  variables {
    test_alb_dns_name = "my-alb-1234.us-east-1.elb.amazonaws.com"
    test_alb_zone_id  = "Z35SXDOTRQ7X7K"
  }
  command = plan

  assert {
    condition     = length(aws_route53_record.alb[0].alias) == 1
    error_message = "Alias block should be present"
  }

  assert {
    condition     = aws_route53_record.alb[0].alias[0].name == "my-alb-1234.us-east-1.elb.amazonaws.com"
    error_message = "Alias target should be ALB domain"
  }

  assert {
    condition     = aws_route53_record.alb[0].alias[0].zone_id == "Z35SXDOTRQ7X7K"
    error_message = "Alias zone ID should be ALB regional zone"
  }

  assert {
    condition     = aws_route53_record.alb[0].alias[0].evaluate_target_health == true
    error_message = "Should evaluate target health for ALB"
  }
}

# --- No networking mode ---

run "skips_alb_record_when_no_alb" {
  variables {
    test_alb_dns_name = ""
    test_alb_zone_id  = ""
  }
  command = plan

  assert {
    condition     = length(aws_route53_record.alb) == 0
    error_message = "ALB record should not be created when no ALB is configured"
  }
}

# --- Common tests ---

run "uses_correct_hosted_zone" {
  variables {
    dns_hosted_zone_id = "ZABCDEFGHIJKL"
    test_alb_dns_name  = "my-alb-1234.us-east-1.elb.amazonaws.com"
    test_alb_zone_id   = "Z35SXDOTRQ7X7K"
  }
  command = plan

  assert {
    condition     = aws_route53_record.alb[0].zone_id == "ZABCDEFGHIJKL"
    error_message = "Record should be in the correct hosted zone"
  }
}

run "handles_subdomain_record" {
  variables {
    dns_full_domain   = "api.prod.example.com"
    test_alb_dns_name = "my-alb-1234.us-east-1.elb.amazonaws.com"
    test_alb_zone_id  = "Z35SXDOTRQ7X7K"
  }
  command = plan

  assert {
    condition     = aws_route53_record.alb[0].name == "api.prod.example.com"
    error_message = "Record name should handle deep subdomains"
  }
}
