# Public EC2 instance
resource "aws_instance" "public" {
  ami                         = var.public_ami_id # custom AMI
  key_name                    = "him"
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "him-prod-public"
  }
}

# Private EC2 instance
resource "aws_instance" "private" {
  ami                         = var.private_ami_id # Amazon Linux 2023 AMI
  key_name                    = "him"
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = false

  tags = {
    Name = "him-prod-private"
  }
}
