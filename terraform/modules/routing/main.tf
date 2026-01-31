# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags   = { Name = "igw-${var.env}" }
}

# Elastic IPs for NAT
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateways
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_ids[0]   # أول public subnet
  tags          = { Name = "nat-${var.env}" }

  depends_on = [aws_internet_gateway.igw]
}


# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "public-rt-${var.env}" }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = { Name = "private-rt-${var.env}" }
}


resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}
