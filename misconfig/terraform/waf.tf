resource "aws_wafv2_web_acl" "misconfig_acl" {
  name        = "misconfig-ACL"
  scope       = "REGIONAL"  

  default_action {
    allow {}
  }

  rule {
    name     = "misconfig-EC2MetadataAcess"
    priority = 0
    action {
      allow {}
    }
    statement {
      byte_match_statement {
        search_string = data.aws_instance.misconfig_ec2_instance.public_ip  # EC2 인스턴스의 퍼블릭 IP를 동적으로 가져옵니다.
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
      metric_name               = "misconfig-EC2MetadataAcess"
    }
  }

  visibility_config {
    sampled_requests_enabled = true
    cloudwatch_metrics_enabled = true
    metric_name               = "misconfig-ACL"
  }

}
