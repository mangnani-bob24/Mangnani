# VPC 생성
resource "aws_vpc" "misconfig_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "misconfig_subnet" {
  vpc_id                  = aws_vpc.misconfig_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "misconfig-subnet"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "misconfig_igw" {
  vpc_id = aws_vpc.misconfig_vpc.id
}

# 라우팅 테이블 생성
resource "aws_route_table" "misconfig_route_table" {
  vpc_id = aws_vpc.misconfig_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.misconfig_igw.id
  }
}

# 퍼블릭 서브넷에 라우팅 테이블 연결
resource "aws_route_table_association" "misconfig_route_table_association" {
  subnet_id      = aws_subnet.misconfig_subnet.id
  route_table_id = aws_route_table.misconfig_route_table.id
}
