resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_eip" "default" {
  count = var.create_private_natgw ? 1 : 0
  vpc   = true
}

resource "aws_nat_gateway" "private-natgw" {
  count             = var.create_private_natgw ? 1 : 0
  connectivity_type = "public"
  allocation_id     = aws_eip.default[0].id
  subnet_id         = aws_subnet.public[0].id
}

resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.vpc.id

  route {
    # machine in this subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    # CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.name}-${var.environment}-public"
    }
  )
}

resource "aws_route_table" "private-crt" {
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.create_private_natgw ? ["create_natgw"] : []
    content {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.private-natgw[0].id
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.name}-${var.environment}-private"
    }
  )
}

resource "aws_route_table_association" "crta-public" {
  for_each       = var.public-subnet-numbers
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public-crt.id
}

resource "aws_route_table_association" "crta-private" {
  for_each       = var.private-subnet-numbers
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private-crt.id
}
