output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = { for k, v in aws_subnet.public : k => v.id }
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = { for k, v in aws_subnet.private : k => v.id }
}