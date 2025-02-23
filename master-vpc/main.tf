resource "aws_vpc" "my_jp_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-jp-vpc"
  }
}