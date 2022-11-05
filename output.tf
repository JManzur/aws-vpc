output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "public_subnet" {
  value       = values(aws_subnet.public)[*].id
  description = "Public Subnets ID"
}

output "private_subnet" {
  value       = values(aws_subnet.private)[*].id
  description = "Private Subnets ID"
}

output "vpc_cidr" {
  value       = var.vpc_cidr
  description = "The VPC CIDR Block"
}