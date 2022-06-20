locals {
  public_cidr   = cidrsubnet(aws_vpc.main.cidr_block, 2, 0)
  private_cidr  = cidrsubnet(aws_vpc.main.cidr_block, 2, 1)
  database_cidr = cidrsubnet(aws_vpc.main.cidr_block, 2, 2)
}

