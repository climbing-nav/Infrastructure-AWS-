variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "서브넷 ID"
  type        = string
}

variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
  default     = "ami-00e73adb2e2c80366"
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH 키 페어 이름"
  type        = string
  default     = "climbingMap_dev_ssh_key"
}

variable "instance_name" {
  description = "EC2 인스턴스 이름"
  type        = string
  default     = "DEV_SERVER"
}
