resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on-launch = true
  tags = {
    Name = "example-subnet"
  }
}

