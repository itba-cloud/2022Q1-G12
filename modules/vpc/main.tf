resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = "true" # gives you an internal domain name
  enable_dns_hostnames = "true" # gives you an internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"
}

resource "aws_subnet" "public" {
  count             = var.zones_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(local.public_cidr, ceil(log(var.zones_count, 2)), count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    name = "public_${count.index}"
  }
}

resource "aws_subnet" "app" {
  count             = var.zones_count
  cidr_block        = cidrsubnet(local.private_cidr, ceil(log(var.zones_count, 2)), count.index)
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    name = "app_${count.index}"
  }
}

resource "aws_subnet" "db" {
  count             = var.zones_count
  cidr_block        = cidrsubnet(local.database_cidr, ceil(log(var.zones_count, 2)), count.index)
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    name = "db_${count.index}"
  }
}
