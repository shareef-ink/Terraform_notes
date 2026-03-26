

resource "aws_instance" "server1" {
 
ami = var.ami_id
instance_type = var.instance_type
key_name = var.key_name
subnet_id = var.subnet_id

tags = {
 Name =var.server_env
}
 
}
