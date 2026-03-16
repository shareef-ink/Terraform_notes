
#cconfigure the aws provider

provider "aws" {
	region = "us-east-1"
 	alias  = "nv"
}

provider "aws" { 
	region = "ap-south-1"
	alias  = "mum"

}



resource "aws_instance" "server1" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  subnet_id     = "subnet-0c8470a98ce167b44"
  key_name      = "Linux"
  count         = 1
 	provider = aws.nv
  tags = {
    Name = "Testing server"
  }
}


# Ec2 instance in mumbai

resource "aws_instance" "server2" {
        	ami = "ami-0f559c3642608c138"
      instance_type = "t3.micro"
          subnet_id = "subnet-0ea03138de78cb106"
	key_name    = "Linux"
	  count	    = 1
	provider    = aws.mum
             tags   = {
        Name        = "Testing server"
 }
}
