# --------------------------------------------------------------------
# Virtual Private Cloud (VPC) network resources
# --------------------------------------------------------------------

###
# Virtual Private Cloud (VPC)
###
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy
  tags = merge(
    {
      "Name" = "${var.environment}-vpc"
    },
    var.tags,
    var.eks_network_tags,
  )
}

###
# Internet Gateway
# ----------------
# We only create this if we actually have public subnets defined and if "enable_igw" 
# is true (this is also the default).   For typical VPC provisioning, this should be 
# left in.  For transit gateway deployments, it may be desirable to not.
###
resource "aws_internet_gateway" "this" {
  count    = length(var.public_subnet_cidrs) > 0 && var.enable_igw ? 1 : 0
  vpc_id   = aws_vpc.this.id
  tags = merge(
    {
      "Name" = "${var.environment}-igw"
    },
    var.tags,
  )
}

###
# NAT Gateway(s)
# --------------
# We only create this if "enable_nat_gw" is true (the default in variables.tf).  However, we also must check
# for the presence of enable_igw because nat_gw objects can't provision in a VPC with no igw present.  For 
# typical VPC provisioning, we want this turned on.  For transit gateway deploys, it depends on whether or not
# we are doing our own self-contained internet egress routing in the VPC or not (if you use transit gateway just 
# to reach shared resource vpc's rather than for data exfiltration controls in a single place, this makes sense.)
###
resource "aws_nat_gateway" "nat_gw" {
  count         = var.enable_nat_gw && var.enable_igw ? local.nat_gw_count : 0
  allocation_id = element(aws_eip.elastic_ip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  tags = merge(
    {
      "Name" = "${var.environment}-natgw-${count.index + 1}"
    },
    var.tags,
  )
}

###
# Elastic IP(s) for NAT Gateway(s) 
# --------------------------------
# See NAT Gateway(s) for the logic on enable_igw
###
resource "aws_eip" "elastic_ip" {
  count    = var.enable_nat_gw && var.enable_igw ? local.nat_gw_count : 0
  vpc      = true
  tags = merge(
    {
      "Name" = "${var.environment}-natgw-elasticIP-${count.index + 1}"
    },
    var.tags,
  )
}

###
# Public Subnets
###
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs) > 0 ? length(var.azs) : 0
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.map_to_public_ip
  tags = merge(
    {
      "Name" = "${var.environment}-public-${element(var.azs, count.index)}-subnet"
    },
    var.tags,
    var.eks_network_tags,
    var.eks_public_subnet_tags
  )
}

###
# Private Subnets
###
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs) > 0 ? length(var.azs) : 0
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = "${var.environment}-private-${element(var.azs, count.index)}-subnet"
    },
    var.tags,
    var.eks_network_tags,
    var.eks_private_subnet_tags,
  )
}

###
# Database Subnets (private)
###
resource "aws_subnet" "private_db_subnets" {
  count                   = length(var.db_subnet_cidrs) > 0 ? length(var.azs) : 0
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.db_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = "${var.environment}-db-${element(var.azs, count.index)}-subnet"
    },
    var.tags,
    var.eks_network_tags,
  )
}

###
# Route table for public subnets
###
resource "aws_route_table" "public" {
  count    = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id   = aws_vpc.this.id
  tags = merge(
    {
      "Name" = "${var.environment}-rt-public"
    },
    var.tags,
  )
}

###
# Route table(s) for private subnets
# ----------------------------------
# This is rather variable, let me break it down:
#       a) Create RT only if we have private and/or db subnets defined 
#       b) If var.single_nat_gw is 'true', we make 1 RT for all non-public subnets
#       c) If var.single_nat_gw is 'false', we make 1 RT per defined AZ in ${var.azs}
resource "aws_route_table" "private" {
  count    = length(var.private_subnet_cidrs) > 0 || length(var.db_subnet_cidrs) > 0 ? local.nat_gw_count : 0
  vpc_id   = aws_vpc.this.id
  tags = merge(
    {
      "Name" = "${var.environment}-rt-private_subnets-${count.index + 1}"
    },
    var.tags,
  )
}

###
# Associate route table with public subnets
# -----------------------------------------
# In current design, we only make 1 public RT, hence all subnets go to that public.id
###
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs) > 0 ? length(var.public_subnet_cidrs) : 0
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

###
# Associate private route table(s) with private subnets
###
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs) > 0 ? length(var.private_subnet_cidrs) : 0
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

###
# Associate private route table(s) with database subnets
###
resource "aws_route_table_association" "db_subnets" {
  count          = length(var.db_subnet_cidrs) > 0 ? length(var.db_subnet_cidrs) : 0
  subnet_id      = element(aws_subnet.private_db_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

###
# VPC Main Route Table association
# --------------------------------
# When creating route tables, we also have the option to make one such route table the default
# This block picks one of them to make such a default, which prevents the automatic route table
# from being automatically generated and then left unassociated with any subnets. Logic inline:
#
# Force the private route table to be the main route table for the VPC if it exists
###
resource "aws_main_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs) > 0 ? 1 : 0
  vpc_id         = aws_vpc.this.id
  route_table_id = element(aws_route_table.private.*.id, 0)
}

###
# If public subnets exist, but no private subnets exist, then force the public route table to be 
# the main route table for the VPC
###
resource "aws_main_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs) > 0 && length(var.private_subnet_cidrs) == 0 ? 1 : 0
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.public[0].id
}

###
# If db subnets exist, but no private or public subnets exist, then force the private route 
# table to be the main route table for the VPC (db_subnets go into the private route table
# in the current design, so this seems duplicate of the first one, but the count logic would
# be too hard to follow without this being it's own resource)
###
resource "aws_main_route_table_association" "db_private" {
  count          = length(var.db_subnet_cidrs) > 0 && length(var.private_subnet_cidrs) == 0 && length(var.public_subnet_cidrs) == 0 ? 1 : 0
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.private[0].id
}

###
# Route(s) to Internet through the NAT Gateway(s)
###
resource "aws_route" "nat_gw_route" {
  count                  = var.enable_nat_gw ? local.nat_gw_count : 0
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat_gw.*.id, count.index)
}

###
# Route(s) to the internet from the Public Route Table if enable_igw is true
###
resource "aws_route" "igw_default_route" {
  count                  = var.enable_igw && length(var.public_subnet_cidrs) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}


