resource "aws_wafv2_web_acl" "vulnswd_waf" {
  name        = "vulnswd-waf"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "vulnswd-waf-metrics"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "block-directory-traversal"
    priority = 1

    action {
      block {}
    }

    statement {
      byte_match_statement {
        search_string         = "../"
        field_to_match {
          query_string {}
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
        positional_constraint = "CONTAINS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "block-directory-traversal"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "waf_assoc" {
  resource_arn = aws_instance.vulnswd_ec2.arn
  web_acl_arn  = aws_wafv2_web_acl.vulnswd_waf.arn
}
