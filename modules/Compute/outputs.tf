output "security_group_id" {
  description = "보안 그룹 ID"
  value       = aws_security_group.web_sg.id
}

output "instance_id" {
  description = "EC2 인스턴스 ID"
  value       = aws_instance.dev_server.id
}

output "instance_public_ip" {
  description = "EC2 인스턴스 퍼블릭 IP"
  value       = aws_instance.dev_server.public_ip
}

output "instance_private_ip" {
  description = "EC2 인스턴스 프라이빗 IP"
  value       = aws_instance.dev_server.private_ip
}

output "instance_public_dns" {
  description = "EC2 인스턴스 퍼블릭 DNS"
  value       = aws_instance.dev_server.public_dns
}
