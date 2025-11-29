output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.climbingmap_vpc.id
}

output "vpc_cidr" {
  description = "VPC CIDR 블록"
  value       = aws_vpc.climbingmap_vpc.cidr_block
}

output "internet_gateway_id" {
  description = "인터넷 게이트웨이 ID"
  value       = aws_internet_gateway.climbingmap_igw.id
}

output "public_subnet_1_id" {
  description = "퍼블릭 서브넷 1 ID"
  value       = aws_subnet.climbingmap_public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "퍼블릭 서브넷 2 ID"
  value       = aws_subnet.climbingmap_public_subnet_2.id
}

output "public_route_table_id" {
  description = "퍼블릭 라우팅 테이블 ID"
  value       = aws_route_table.climbingmap_public_rtb.id
}
