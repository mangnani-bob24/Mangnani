# ALB security groups
resource "aws_security_group" "misconfig_ALBSecurityGroup_terraform" {
    name = "misconfig_ALBsecurityGroup_terraform"
    vpc_id = aws_vpc.misconfig_vpc.id  # VPC를 동적으로 참조

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# ALB resource
resource "aws_lb" "misconfig_lb_terraform" {
  name               = "misconfig-LB-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.misconfig_ALBSecurityGroup_terraform.id]
  subnets            = [
    aws_subnet.misconfig_subnet_az1.id,
    aws_subnet.misconfig_subnet_az2.id
  ]
  enable_deletion_protection = false
  idle_timeout              = 60

  enable_cross_zone_load_balancing = true
  ip_address_type = "ipv4"

  access_logs {
    bucket = "my-alb-logs"
    enabled = true
  }
}

# 타겟 그룹 리소스
resource "aws_lb_target_group" "misconfig_tg_terraform" {
  name        = "misconfig-TG-terraform"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.misconfig_vpc.id  # VPC 동적 참조
  target_type = "instance"

  health_check {
    protocol           = "HTTP"
    port               = "80"
    path               = "/health"
    interval           = 30
    timeout            = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  tags = {
    Name = "misconfig-TG"
  }
}

# EC2 인스턴스를 타겟 그룹에 등록
resource "aws_lb_target_group_attachment" "misconfig_tg_attachment" {
  target_group_arn = aws_lb_target_group.misconfig_tg_terraform.arn
  target_id        = aws_instance.misconfig_ec2.id
  port             = 80
}

# ALB 리스너 리소스
resource "aws_lb_listener" "misconfig_lb_listener" {
  load_balancer_arn = aws_lb.misconfig_lb_terraform.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.misconfig_tg_terraform.arn
  }

  tags = {
    Name = "misconfig-LB-listener"
  }
}

# HTTPS 리스너와 SSL 인증서 설정
resource "aws_acm_certificate" "misconfig_ssl" {
  domain_name       = "example.com"  # 실제 도메인으로 변경
  validation_method = "DNS"
}

resource "aws_lb_listener" "misconfig_lb_listener_https" {
  load_balancer_arn = aws_lb.misconfig_lb_terraform.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.misconfig_tg_terraform.arn
  }

  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = aws_acm_certificate.misconfig_ssl.arn
}

# WAF와 ALB 연결 (선택 사항)
resource "aws_wafv2_web_acl_association" "misconfig_waf_association" {
  resource_arn = aws_lb.misconfig_lb_terraform.arn
  web_acl_arn  = aws_wafv2_web_acl.misconfig_acl.arn
}

# ALB DNS 이름, ARN, 그리고 타겟 그룹 ARN 출력
output "alb_dns_name" {
  value = aws_lb.misconfig_lb_terraform.dns_name
}

output "alb_arn" {
  value = aws_lb.misconfig_lb_terraform.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.misconfig_tg_terraform.arn
}
