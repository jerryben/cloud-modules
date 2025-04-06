resource "aws_eip" "nat" {
  count = length(var.public_subnet_ids)

  tags = {
    Name        = "${var.environment}-nat-eip-${count.index}"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = {
    Name        = "${var.environment}-nat-gateway-${count.index}"
    Environment = var.environment
  }
}
