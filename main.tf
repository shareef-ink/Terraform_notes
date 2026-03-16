

provider "aws" {

 region = "us-east-1"

}


# 1. create a VPC  - 10.81.0.0/16

resource "aws_vpc" "prod_vpc" {
  
    cidr_block = "10.81.0.0/16"
    tags = {
      Name = "Prod-VPC"
    }

}


  # 2. Create Internet Gateway 

resource "aws_internet_gateway" "prod_gw" {

    vpc_id = aws_vpc.prod_vpc.id

    tags = {
      Name = "Prod-IGW"
    }

}

#  3. Create Custom Route Table 

resource "aws_route_table" "prod_rt" {
    vpc_id = aws_vpc.prod_vpc.id

route {
      cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.prod_gw.id
        }

    tags = {
      Name = "Prod-RT"
    }
  
}



#   4. Create a public Subnet  -- 10.81.3.0/24

resource "aws_subnet" "prod_sn" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = "10.81.3.0/24"


    tags = {
      Name = "Prod-Public-SN"
    }
  
}

# 5. Associate Route Table with Subnet      
resource "aws_route_table_association" "prod_rta" {
    subnet_id = aws_subnet.prod_sn.id
    route_table_id = aws_route_table.prod_rt.id
}



 # 6. Create Security Group to allow port 22,80,443 or all ports , traffic 

 resource "aws_security_group" "prod_sg" {
    name = "prod-sg"
    description = "Allow all traffic"
    vpc_id = aws_vpc.prod_vpc.id

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }


    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

      egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
   
 }

 tags = {
      Name = "Prod-SG"
    }

 }

 #  7. Create a network interface with an ip in the subnet that was created in step 4  

resource "aws_network_interface" "prod_eni" {
    subnet_id = aws_subnet.prod_sn.id
    private_ips = ["10.81.3.33"]
    security_groups = [aws_security_group.prod_sg.id]
    tags = {
      Name = "Prod-ENI"
    }

}

#  8. Assign an elastic IP to the network interface created in step 7 

resource "aws_eip" "prod_eip" {
    network_interface = aws_network_interface.prod_eni.id
    domain = "vpc"
 #   private_ip = aws_network_interface.prod_eni.private_ips[0]
    tags = {
      Name = "Prod-EIP"
    }
}

# 9. Create an ec2  server - LAUNCH APLICATION IN IT 

resource "aws_instance" "prod_server" {
  
  ami = "ami-02dfbd4ff395f2a1b"
  instance_type = "t2.micro"
  key_name = "batch17a"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.prod_eni.id
    }
  
  user_data = file("facebook.sh")

  tags = {
    Name = "Prod-fb-Server"
  }



}

output "fb-eip" {
    value = aws_eip.prod_eip.public_ip
}
