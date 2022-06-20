###
## Public
###
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route" "public_ig" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = var.zones_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

###
## Private
###
resource "aws_route_table" "private" {
  count  = var.zones_count
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private_${count.index}"
  }
}

resource "aws_route" "private_natgw" {
  count                  = var.natgw ? var.zones_count : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = var.zones_count
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}