variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A map of CIDR blocks for the public subnets."
  type        = map(string)
}

variable "private_subnet_cidrs" {
  description = "A map of CIDR blocks for the private subnets."
  type        = map(string)
}

variable "availability_zones" {
  description = "Map of subnet names to AZs."
  type        = map(string)
}