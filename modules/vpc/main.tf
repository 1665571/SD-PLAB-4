resource "aws_vpc" "main" {
    cidr_block           = var.cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "public" {
    for_each = var.public_subnet_cidrs

    vpc_id            = aws_vpc.main.id
    cidr_block        = each.value
    availability_zone = var.availability_zones[each.key]

    tags = {
        Name = "${var.vpc_name}-public-${each.key}"
    }
}

resource "aws_subnet" "private" {
    for_each = var.private_subnet_cidrs

    vpc_id            = aws_vpc.main.id
    cidr_block        = each.value
    availability_zone = var.availability_zones[each.key]

    tags = {
        Name = "${var.vpc_name}-private-${each.key}"
    }
}