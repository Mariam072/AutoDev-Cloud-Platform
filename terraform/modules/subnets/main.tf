# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "public-${count.index}-${var.env}" }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + length(var.azs))
  availability_zone = var.azs[count.index]
  tags = { Name = "private-${count.index}-${var.env}" }
}

# Data Subnets
resource "aws_subnet" "data" {
  count             = length(var.azs)
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 2*length(var.azs))
  availability_zone = var.azs[count.index]
  tags = { Name = "data-${count.index}-${var.env}" }
}

