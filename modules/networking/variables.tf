variable "vpc_cidr" {
    type = string
}

variable "vpc_name" {
    type = string
    default = "VPC-PLAB4"
}

variable "igw_name" {
    type = string
    default = "IGW-PLAB4"
}

variable "public_subnet_cidr" {
    type = list(string)
}

variable "private_subnet_cidr" {
    type = list(string)
}

variable "availability_zones" {
    type = list(string)
}
