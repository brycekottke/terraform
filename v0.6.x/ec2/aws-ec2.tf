provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "template_file" "bootstrap" {
  template = "${file("${path.module}/scripts/bootstrap.sh")}"
  vars {
    pub_key = "${var.pub_key}"
  }
}

resource "aws_instance" "dev-terraform-1" {
  ami = "${var.ami_image}"
  instance_type = "${var.instance_type}"
  count = "2"
  subnet_id = "subnet-c84ab4ac"
  vpc_security_group_ids = [ "sg-1900847e" ]
  key_name = "bkottke-dev"
  user_data = "${template_file.bootstrap.rendered}"
  tags {
    Name = "${var.ec2_name}-${count.index + 1}"
    environment = "${var.ec2_environment}"
  }
}
