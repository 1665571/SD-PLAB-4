######################################
## VPC 
######################################

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = var.vpc_name
    }
}

######################################
## Internet Gateway
######################################

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.vpc.id
    
    tags = {
        Name = var.igw_name
    }
}

######################################
## Public Subnets
######################################

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidr)
    
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
}

## Private Subnets
resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidr)
    
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
}

######################################
## Elastic IPs for NAT Gateways
######################################

resource "aws_eip" "nat_eip" {
    count = length(var.public_subnet_cidr)
    
    domain = "vpc"
    
    tags = {
        Name = "nat-eip-${count.index + 1}"
    }
    
    depends_on = [aws_internet_gateway.igw]
}

######################################
## NAT Gateway
######################################

resource "aws_nat_gateway" "nat" {
    count = length(var.public_subnet_cidr)
    
    allocation_id = aws_eip.nat_eip[count.index].id
    subnet_id = aws_subnet.public[count.index].id
    depends_on = [aws_internet_gateway.igw]
}

######################################
## Route Tables 
######################################

## Public

resource "aws_route_table" "public" {    
    vpc_id = aws_vpc.vpc.id
    
    route {
        cidr_block = local.any_IPv4
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "public-route_table"
    }
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)

    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

## Private

resource "aws_route_table" "private" {
    count = length(var.private_subnet_cidr)

    vpc_id = aws_vpc.vpc.id
    
    route {
        cidr_block = local.any_IPv4
        gateway_id = aws_nat_gateway.nat[count.index].id
    }

    tags = {
        Name = "private-route-table-${count.index + 1}"
    }
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.privat[count.index].id
}

locals{
    any_IPv4 = "0.0.0.0/0"
}