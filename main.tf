

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


