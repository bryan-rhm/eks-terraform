# -------------------------------------------------------------
# VPC outputs
# -------------------------------------------------------------
output "vpc_id" {
  description = "ID of the provisioned VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR of the overall environment config (covering all subnets)"
  value       = var.vpc_cidr
}

output "azs" {
  description = "List of Availability Zones provisioned within"
  value       = var.azs
}

output "public_subnet_ids" {
  description = "List of public subnet IDs provisioned"
  value       = aws_subnet.public_subnets.*.id
}

output "public_subnet_cidrs" {
  description = "List of public subnet cidr blocks provisioned"
  value       = var.public_subnet_cidrs
}

output "private_subnet_ids" {
  description = "List of private subnet IDs provisioned"
  value       = aws_subnet.private_subnets.*.id
}

output "private_subnet_cidrs" {
  description = "List of private subnet cidr blocks provisioned"
  value       = var.private_subnet_cidrs
}

output "db_subnet_ids" {
  description = "List of database subnet IDs provisioned"
  value       = aws_subnet.private_db_subnets.*.id
}

output "db_subnet_cidrs" {
  description = "List of database subnet cidr blocks provisioned"
  value       = var.db_subnet_cidrs
}

output "database_subnets_azs" {
  description = "List of the AZ for the subnet"
  value       = aws_subnet.private_db_subnets.*.availability_zone
}

output "igw_id" {
  description = "Internet Gateway ID provisioned"
  value       = join(",", aws_internet_gateway.this.*.id)
}

output "nat_gw_ids" {
  description = "List of NAT Gateway IDs provisioned"
  value       = aws_nat_gateway.nat_gw.*.id
}