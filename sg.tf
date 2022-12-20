resource "aws_security_group" "bastion-server" {
  name          = "SSH security group"
  vpc_id        = var.vpc
  description   = "Security Group for Bastion server"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "SSH security group"
  }
}