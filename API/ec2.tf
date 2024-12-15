# 데이터 소스 선언
data "aws_availability_zones" "available" {}

# VPC 생성 및 DNS 속성 활성화
resource "aws_vpc" "ctf_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true  # DNS Support 활성화
  enable_dns_hostnames = true  # DNS Hostnames 활성화

  tags = {
    Name = "CTF-VPC"
  }
}

# 서브넷 생성 (퍼블릭 서브넷)
resource "aws_subnet" "ctf_subnet" {
  vpc_id                  = aws_vpc.ctf_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "CTF-Subnet"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "ctf_igw" {
  vpc_id = aws_vpc.ctf_vpc.id

  tags = {
    Name = "CTF-InternetGateway"
  }
}

# 라우팅 테이블 생성 및 인터넷 연결 설정
resource "aws_route_table" "ctf_route_table" {
  vpc_id = aws_vpc.ctf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ctf_igw.id
  }

  tags = {
    Name = "CTF-RouteTable"
  }
}

# 서브넷과 라우팅 테이블 연결
resource "aws_route_table_association" "ctf_route_assoc" {
  subnet_id      = aws_subnet.ctf_subnet.id
  route_table_id = aws_route_table.ctf_route_table.id
}

# SSM 통신용 보안 그룹
resource "aws_security_group" "ssm_sg" {
  name        = "SSM-SecurityGroup"
  description = "Allow SSM traffic"
  vpc_id      = aws_vpc.ctf_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SSM 엔드포인트 (Interface 유형)
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.ctf_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"  # Interface 유형 설정
  subnet_ids        = [aws_subnet.ctf_subnet.id]
  security_group_ids = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true
}

# EC2 메시지 엔드포인트 (Interface 유형)
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.ctf_vpc.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"  # Interface 유형 설정
  subnet_ids        = [aws_subnet.ctf_subnet.id]
  security_group_ids = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true
}

# SSM 메시지 엔드포인트 (Interface 유형)
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.ctf_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"  # Interface 유형 설정
  subnet_ids        = [aws_subnet.ctf_subnet.id]
  security_group_ids = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true
}

# EC2 인스턴스 생성
resource "aws_instance" "ctf_instance" {
  ami                  = "ami-023ff3d4ab11b2525"  # 적절한 AMI ID로 수정
  instance_type        = var.instance_type
  user_data            = file("${path.module}/userdata.sh")
  vpc_security_group_ids = [aws_security_group.ssm_sg.id]
  subnet_id            = aws_subnet.ctf_subnet.id

  tags = {
    Name = "CTF-Instance"
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
}

# IAM 및 SSM 설정
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "SSMInstanceProfile-New"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role" "ssm_role" {
  name_prefix = "SSMRole-New-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
