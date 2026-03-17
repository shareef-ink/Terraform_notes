provider "aws" {
	 
	region = "us-east-1"
}
 

# 1. create a vpc 10.19.0.0/16

resource "aws_vpc" "shareef_vpc" {

	cidr_block = "10.19.0.0/16"
	tags = {
	Name = "shareef_vpc"
 }
}


# 2. create Internat gateway

 resource "aws_internet_gateway" "shareef_IG" {

	vpc_id = aws_vpc.shareef_vpc.id

	tags = {
    	
	Name = "shareef-IG"
 }
}


# 3. create custom route table

 resource "aws_route_table" "shareef_rt" {
	
	vpc_id = aws_vpc.shareef_vpc.id

route { 

	cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.shareef_IG.id
 } 

 	tags =  {
	
	Name = "shareef-RT"
	}
}

# 4. create a public subnet -- 10.19.100.0/24

resource "aws_subnet" "shareef_sn" {
	
	vpc_id = aws_vpc.shareef_vpc.id 
	cidr_block = "10.19.100.0/24"

	tags = {
 	Name = "shareef-public-sn"
 }

}



# 5. Associate Route Table with subnet

resource "aws_route_table_association" "shareef_rta" {
	subnet_id = aws_subnet.shareef_sn.id
	route_table_id = aws_route_table.shareef_rt.id

}



# 6. create security group to allow port 22,80,443,or all ports traffic

resource "aws_security_group" "shareef_sg" {

	name = "shareef-sg"
	description = "Allow ll traffic"
	vpc_id	= aws_vpc.shareef_vpc.id


	ingress {
	  from_port = 22 
	  to_port   = 22
	  protocol  = "tcp"
	  cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
	  from_port = 80
	  to_port   = 80
	  protocol  = "tcp"
	  cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
	  from_port = 443
	  to_port   = 443
	  protocol  = "tcp"
	  cidr_blocks = ["0.0.0.0/0"]

	}

 	egress {
	  from_port = 0
	  to_port  = 0
	  protocol  ="-1"
	  cidr_blocks = ["0.0.0.0/0"]
	}
	
	tags =  {
	Name = "shareef-sg"

	}
}

# 7. create a network interface with an ip in the subnet that was created in step

 
 resource "aws_network_interface" "shareef_eni" {
	subnet_id = aws_subnet.shareef_sn.id
	private_ips = ["10.19.100.143"]
	security_groups = [aws_security_group.shareef_sg.id]
	tags  = {
	Name = "shareef-eni"
	}
}


# 8. Assign an elastic ip to the network interface

 resource "aws_eip" "shareef_eip" {
	network_interface = aws_network_interface.shareef_eni.id
	domain = "vpc"
	
	tags = {
	Name = "shareef-eip"
	}

}


# 9. create a ec2 server 

 resource "aws_instance" "shareef_server" {
	instance_type = "t3.micro"
	key_name      = "Linux"
	ami = "ami-02dfbd4ff395f2a1b"
	network_interface {
	 device_index = 0
	network_interface_id = aws_network_interface.shareef_eni.id

	}
	
	user_data = file("facebook.sh")
	
	tags = {
	Name = "shareef-fb-server"
	}

}
 

output "fb-eip" {

	value = aws_eip.shareef_eip.public_ip
	
}

