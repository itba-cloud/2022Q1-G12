resource "aws_iam_policy" "policy_rds" {
  count = length(var.db_subnets)

  name = "replication-policy-${count.index}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["rds:CreateDBInstanceReadReplica"]
        Effect = "Allow"
        Resource = [
          "arn:aws:rds:::${local.replica_name}-${count.index}"
        ]
      },
    ]
  })
}

resource "aws_security_group" "rds" {
  name   = "terraform_rds_security_group"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
}
