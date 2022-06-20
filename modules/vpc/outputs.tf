output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = aws_vpc.main.cidr_block
}

output "public_subnets_ids" {
  value = aws_subnet.public[*].id
}

output "app_subnets_ids" {
  value = aws_subnet.app[*].id
}

output "db_subnets_ids" {
  value = aws_subnet.db[*].id
}

output "privateDB_subnets_ids" {
  value = [for k, v in aws_subnet.db : v.id]
}
