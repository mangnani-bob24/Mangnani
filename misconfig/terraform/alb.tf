# ALB 보안 그룹
resource "aws_security_group" "misconfig_alb_sg" {
  name        = "misconfig-ALB-SecurityGroup"
  description = "Security group for misconfig ALB"
  vpc_id      = "vpc-0080a5b383f4fe2cc"  # ALB가 위치할 VPC

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 모든 IP 주소에서 80 포트(HTTP)로 접근 허용
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 모든 IP 주소에서 443 포트(HTTPS)로 접근 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # 모든 아웃바운드 트래픽 허용
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB 리소스
resource "aws_lb" "misconfig_lb" {
  name               = "misconfig-LB"
  internal           = false  # 인터넷에서 액세스 가능하게 설정 (Internet-facing)
  load_balancer_type = "application"  # 애플리케이션 로드 밸런서
  security_groups    = [aws_security_group.misconfig_alb_sg.id]  # ALB에 연결할 보안 그룹
  subnets            = [
    "subnet-06ed03f9dad422820",  # ap-northeast-1c (AZ1)
    "subnet-05b672f05c970dd5d"   # ap-northeast-1d (AZ2)
  ]
  enable_deletion_protection = false  # 삭제 보호 비활성화
  idle_timeout              = 60     # 대기 시간 설정 (초)

  enable_cross_zone_load_balancing = true  # 교차 AZ 로드 밸런싱 활성화
  ip_address_type = "ipv4"  # IP 주소 타입 IPv4 설정

  access_logs {
    bucket = "my-alb-logs"  # S3 버킷에 로그를 저장
    enabled = true
  }
}

# 타겟 그룹 리소스
resource "aws_lb_target_group" "misconfig_tg" {
  name        = "misconfig-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0080a5b383f4fe2cc"  # ALB가 속한 VPC
  target_type = "instance"  # EC2 인스턴스를 대상으로 설정

  health_check {
    protocol           = "HTTP"
    port               = "80"
    path               = "/health"
    interval           = 30  # 헬스 체크 주기 (초)
    timeout            = 5   # 응답 대기 시간 (초)
    healthy_threshold  = 2   # 정상 상태 판단을 위한 임계값
    unhealthy_threshold = 2  # 비정상 상태 판단을 위한 임계값
  }

  stickiness {
    type    = "lb_cookie"
    enabled = false  # 스틱니스(세션 지속성) 비활성화
  }

  tags = {
    Name = "misconfig-TG"
  }
}

# EC2 인스턴스를 타겟 그룹에 등록
resource "aws_lb_target_group_attachment" "misconfig_tg_attachment" {
  target_group_arn = aws_lb_target_group.misconfig_tg.arn
  target_id        = aws_instance.misconfig_ec2.id  # EC2 인스턴스 ID
  port             = 80
}

# ALB 리스너 리소스
resource "aws_lb_listener" "misconfig_lb_listener" {
  load_balancer_arn = aws_lb.misconfig_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.misconfig_tg.arn  # 트래픽을 타겟 그룹으로 전달
  }

  tags = {
    Name = "misconfig-LB-listener"
  }
}

# HTTPS 리스너와 SSL 인증서 설정
resource "aws_acm_certificate" "misconfig_ssl" {
  domain_name       = "example.com"
  validation_method = "DNS"
}

resource "aws_lb_listener" "misconfig_lb_listener_https" {
  load_balancer_arn = aws_lb.misconfig_lb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.misconfig_tg.arn  # 트래픽을 타겟 그룹으로 전달
  }

  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = aws_acm_certificate.misconfig_ssl.arn  # SSL 인증서 적용
}

# WAF와 ALB 연결 (선택 사항)
resource "aws_wafv2_web_acl_association" "misconfig_waf_association" {
  resource_arn = aws_lb.misconfig_lb.arn
  web_acl_arn  = aws_wafv2_web_acl.misconfig_acl.arn
}

# ALB DNS 이름, ARN, 그리고 타겟 그룹 ARN 출력
output "alb_dns_name" {
  value = aws_lb.misconfig_lb.dns_name
}

output "alb_arn" {
  value = aws_lb.misconfig_lb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.misconfig_tg.arn
}
