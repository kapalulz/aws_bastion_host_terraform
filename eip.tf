resource "aws_eip" "bastion" {
  vpc    = true
  tags = {
    Name = "BastionIP"
  }
}