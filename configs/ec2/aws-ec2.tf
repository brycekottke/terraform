provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "example" {
    ami = "ami-9abea4fb"
    instance_type = "t2.micro"
    tags {
        Name = "dev-terraform-1"
        environment = "dev"
    }
}
