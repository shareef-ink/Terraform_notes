 
variable "ami_id" {

description  = "ami-value"
default  = "ami-02dfbd4ff395f2a1b"

}

variable "instance_type" {

description = "instance type for the ec2 instance"
default = "t3.micro"

}

variable "key_name" {

description = "kay pair for the ec2 instance"
default = "Linux"

}

variable "server_env" {

description = "Environment fot the server"
default = "shareef-server"

}

variable "subnet_id" {

description = "subnet id for the instance"
default = "subnet-0c8470a98ce167b44"
}
