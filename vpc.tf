# Creating VPC
resource "aws_vpc" "my-vpc" {
    cidr_block = "192.168.1.0/28"

    tags = {
      Name = "MyVPC"
    }
}

# Create a public subnet in the VPC
resource "aws_subnet" "my-subnet-pub" {
    vpc_id = aws_vpc.my-vpc.id
    availability_zone = "us-east-1a"
    cidr_block = "192.168.1.0/28"
    map_public_ip_on_launch = true

    tags = {
      Name = "my-subnet-public"
    }
}

# Create a private subnet in the VPC
resource "aws_subnet" "my-subnet-pri" {
    vpc_id = aws_vpc.my-vpc.id
    availability_zone = "us-east-1a"
    cidr_block = "192.168.1.128/30"
    map_public_ip_on_launch = false

    tags = {
      Name = "my-subnet-private"
    }
}

# Creating Internet gateway
resource "aws_internet_gateway" "my-ig" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
      Name = "my-igw"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-ig.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "my-public-subnet-assoc" {
  subnet_id      = aws_subnet.my-subnet-pub.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a route table for the private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my-vpc.id

  # No route to the internet for private subnet
  # This ensures private subnet doesn't have outbound internet access
  tags = {
    Name = "PrivateRouteTable"
  }
}

# Associate the private subnet with the route table
resource "aws_route_table_association" "my-private-subnet-assoc" {
  subnet_id      = aws_subnet.my-subnet-pri.id
  route_table_id = aws_route_table.private_route_table.id
}
