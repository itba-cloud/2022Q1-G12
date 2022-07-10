resource "aws_instance" "bastion" {
  count                       = length(var.subnets)
  ami                         = var.ami
  key_name                    = var.key_name
  instance_type               = var.instance_type
  subnet_id                   = var.subnets[count.index]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion_${count.index}"
  }
}
