# waf acl resource
resource "aws_wafv2_web_acl" "misconfig_acl_terraform" {
  name        = "Misconfig-ACL-terraform"
  scope       = "REGIONAL"  

  default_action {
    allow {}
  }

  rule {
    name     = "Misconfig-EC2MetadataAcess"
    priority = 0
    action {
      allow {}
    }
    statement {
      byte_match_statement {
        search_string = data.aws_instance.misconfig_ec2_terraform.public_ip 
        field_to_match {
          query_string {}
        }
        positional_constraint = "EXACTLY"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }
    visibility_config {
      sampled_requests_enabled = true
      cloudwatch_metrics_enabled = true
      metric_name               = "Misconfig-EC2MetadataAcess"
    }
  }

  visibility_config {
    sampled_requests_enabled = true
    cloudwatch_metrics_enabled = true
    metric_name               = "Misconfig-ACL-terraform"
  }

}

# attach waf to alb
resource "aws_wafv2_web_acl_association" "misconfig_waf_association" {
  resource_arn = aws_lb.misconfig_lb_terraform.arn
  web_acl_arn  = aws_wafv2_web_acl.misconfig_acl_terraform.arn
}


# data resource
data "aws_instance" "misconfig_ec2_terraform" {
  instance_id = "${aws_instance.misconfig_ec2_terraform.id}"
}
