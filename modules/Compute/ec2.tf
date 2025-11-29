# 보안 그룹 - WEB-SG
resource "aws_security_group" "web_sg" {
  name        = "WEB-SG"
  description = "allow from ALB to WEB for Client"
  vpc_id      = var.vpc_id

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Vite Dev Server
  ingress {
    description = "Vite Dev Server"
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 아웃바운드 모두 허용
  egress {
    description = "All outbound traffic allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WEB-SG"
  }
}

# EC2 인스턴스 - DEV_SERVER
resource "aws_instance" "dev_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Private IP 고정 (선택사항)
  # private_ip = "192.168.1.93"

  # 루트 볼륨 설정
  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = false
  }

  # 메타데이터 옵션
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
  }

  tags = {
    Name = var.instance_name
  }
}

# Elastic IP (필요시 주석 해제)
# resource "aws_eip" "dev_server_eip" {
#   instance = aws_instance.dev_server.id
#   domain   = "vpc"
#
#   tags = {
#     Name = "${var.instance_name}-EIP"
#   }
# }
