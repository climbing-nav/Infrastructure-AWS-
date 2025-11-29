# VPC 모듈
module "vpc" {
  source = "./modules/VPC"

  vpc_name              = "climbingMap-vpc"
  vpc_cidr              = "192.168.0.0/20"
  public_subnet_1_cidr  = "192.168.0.0/24"
  public_subnet_2_cidr  = "192.168.1.0/24"
  availability_zone_1   = "ap-northeast-2a"
  availability_zone_2   = "ap-northeast-2c"
}

# Compute 모듈 (EC2 및 보안 그룹)
module "compute" {
  source = "./modules/Compute"

  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_2_id
  ami_id        = "ami-00e73adb2e2c80366"
  instance_type = "t2.micro"
  key_name      = "climbingMap_dev_ssh_key"
  instance_name = "DEV_SERVER"
}

# 출력값
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_1_id" {
  description = "퍼블릭 서브넷 1 ID"
  value       = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "퍼블릭 서브넷 2 ID"
  value       = module.vpc.public_subnet_2_id
}

output "dev_server_id" {
  description = "DEV 서버 인스턴스 ID"
  value       = module.compute.instance_id
}

output "dev_server_public_ip" {
  description = "DEV 서버 퍼블릭 IP"
  value       = module.compute.instance_public_ip
}

output "dev_server_private_ip" {
  description = "DEV 서버 프라이빗 IP"
  value       = module.compute.instance_private_ip
}