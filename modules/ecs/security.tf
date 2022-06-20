resource "aws_security_group" "ecs_tasks" {
  name   = "ecs-sg"
  vpc_id = var.vpc_id

    ingress {
    from_port         = 0
    to_port           = 0
    protocol          = "icmp"
    cidr_blocks       = [var.vpc_cidr]
  }

  ingress {
    protocol          = "tcp"
    from_port         = 80
    to_port           = 80
    cidr_blocks       = [var.vpc_cidr]
  }

  ingress {
    protocol          = "tcp"
    from_port         = 443
    to_port           = 443
    cidr_blocks       = [var.vpc_cidr]
  }

  egress {
    protocol          = "-1"
    from_port         = 0
    to_port           = 0
    # Permitimos a los servicios salir a internet libremente, para hablar por ejemplo con procesadores de pagos.
    # De todas maneras controlamos la seguridad ingress estrictamente
    cidr_blocks       = ["0.0.0.0/0"] 
  }
}
