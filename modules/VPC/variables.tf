variable "vpc_name" {
  description = "VPC 이름"
  type        = string
  default     = "climbingMap-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "192.168.0.0/20"
}

variable "public_subnet_1_cidr" {
  description = "퍼블릭 서브넷 1 CIDR 블록"
  type        = string
  default     = "192.168.0.0/24"
}

variable "public_subnet_2_cidr" {
  description = "퍼블릭 서브넷 2 CIDR 블록"
  type        = string
  default     = "192.168.1.0/24"
}

variable "availability_zone_1" {
  description = "첫 번째 가용 영역"
  type        = string
  default     = "ap-northeast-2a"
}

variable "availability_zone_2" {
  description = "두 번째 가용 영역"
  type        = string
  default     = "ap-northeast-2c"
}
