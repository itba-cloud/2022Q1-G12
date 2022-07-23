resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "main_natgw" {
  count = var.natgw ? var.zones_count : 0
  vpc   = true
}

resource "aws_nat_gateway" "main" {
  count         = var.natgw ? var.zones_count : 0
  allocation_id = aws_eip.main_natgw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}
