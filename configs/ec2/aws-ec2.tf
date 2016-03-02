provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "dev-terraform-1" {
    ami = "${var.ami_image}"
    instance_type = "${var.instance_type}"
    tags {
        Name = "${var.ec2_name}"
        environment = "${var.ec2_environment}"
    }
    provisioner "local-exec" {
        command = "mkdir /home/ubuntu/.ssh && echo ${var.pub_key} > /home/ubuntu/.ssh/authorized_keys"
    }
}
