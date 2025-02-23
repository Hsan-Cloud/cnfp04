resource "aws_subnet" "my_jp_subnet" {
  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "my-jp-subnet"
  }
}
