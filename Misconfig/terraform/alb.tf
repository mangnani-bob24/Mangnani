# ALB security groups
resource "aws_security_group" "misconfig_ALBSecurityGroup_terraform" {
    name = "Misconfig-ALBSecurityGroup-terraform"
    vpc_id = "${aws_vpc.misconfig_vpc.id}"

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
  name               = "Misconfig-LB-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.misconfig_ALBSecurityGroup_terraform.id]
  subnets            = [
    "${aws_subnet.misconfig_subnet_az1.id}",
    "${aws_subnet.misconfig_subnet_az2.id}"
  ]
  enable_deletion_protection = false
  idle_timeout              = 60

  enable_cross_zone_load_balancing = true
  ip_address_type = "ipv4"

}

# 타겟 그룹 리소스
resource "aws_lb_target_group" "misconfig_tg_terraform" {
  name        = "Misconfig-TG-terraform"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.misconfig_vpc.id}"
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
    Name = "Misconfig-TG-terraform"
  }
}

# EC2 인스턴스를 타겟 그룹에 등록
resource "aws_lb_target_group_attachment" "misconfig_tg_attachment_terraform" {
  target_group_arn = aws_lb_target_group.misconfig_tg_terraform.arn
  target_id        = "${aws_instance.misconfig_ec2_terraform.id}"
  port             = 80
}

# ALB 리스너 리소스
resource "aws_lb_listener" "misconfig_lb_listener_terraform" {
  load_balancer_arn = aws_lb.misconfig_lb_terraform.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.misconfig_tg_terraform.arn}"
  }

  tags = {
    Name = "Misconfig-LB-Listener-terraform"
  }
}

# WAF와 ALB 연결 (선택 사항)
resource "aws_wafv2_web_acl_association" "misconfig_waf_association_terraform" {
  resource_arn = aws_lb.misconfig_lb_terraform.arn
  web_acl_arn  = aws_wafv2_web_acl.misconfig_acl_terraform.arn
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
