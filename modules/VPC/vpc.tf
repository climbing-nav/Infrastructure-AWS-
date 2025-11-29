# VPC 생성
resource "aws_vpc" "climbingmap_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "climbingmap_igw" {
  vpc_id = aws_vpc.climbingmap_vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# 퍼블릭 서브넷 1 (ap-northeast-2a)
resource "aws_subnet" "climbingmap_public_subnet_1" {
  vpc_id                  = aws_vpc.climbingmap_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-subnet-public1-${var.availability_zone_1}"
  }
}

# 퍼블릭 서브넷 2 (ap-northeast-2c)
resource "aws_subnet" "climbingmap_public_subnet_2" {
  vpc_id                  = aws_vpc.climbingmap_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-subnet-public2-${var.availability_zone_2}"
  }
}

# 퍼블릭 라우팅 테이블
resource "aws_route_table" "climbingmap_public_rtb" {
  vpc_id = aws_vpc.climbingmap_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.climbingmap_igw.id
  }

  tags = {
    Name = "${var.vpc_name}-rtb-public"
  }
}

# 라우팅 테이블 연결 - 서브넷 1
resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.climbingmap_public_subnet_1.id
  route_table_id = aws_route_table.climbingmap_public_rtb.id
}

# 라우팅 테이블 연결 - 서브넷 2
resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.climbingmap_public_subnet_2.id
  route_table_id = aws_route_table.climbingmap_public_rtb.id
}
