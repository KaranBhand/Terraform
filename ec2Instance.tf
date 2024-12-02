resource "aws_key_pair" "Terraform-Key" {
    key_name = "MyTerraformKey"
    public_key = file("MyTerraformKey.pub")
}

resource "aws_default_vpc" "default" {
  
}
resource "aws_security_group" "my_sg" {
    name = "My_SG_Group"
    description = "This is a security group by terraform"
    vpc_id = aws_default_vpc.default.id #Interpolation

    ingress {
        description = "allow aceess 22"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow aceess 80"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     egress {
        description = "Allow all traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }   

}

resource "aws_instance" "my_instance" {
    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.my_sg.name] #Interpolation
    key_name = aws_key_pair.Terraform-Key.key_name
    root_block_device {
      volume_size = 10
      volume_type = "gp3"
    }
}
