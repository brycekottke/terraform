provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  tags { 
    Name = "${var.name}"
    environment = "${var.ec2_environment}"
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags { 
    Name = "${var.name}-public"
    environment = "${var.ec2_environment}"
  }
}

resource "aws_route" "public_internet_gateway" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc.id}"
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count = "${length(compact(split(",", var.public_subnets)))}"
  tags { 
    Name = "${var.name}-public"
    environment = "${var.ec2_environment}"
  }
  map_public_ip_on_launch = true
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags { 
    Name = "${var.name}-private"
    environment = "${var.ec2_environment}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count = "${length(compact(split(",", var.private_subnets)))}"
  tags { 
    Name = "${var.name}-private"
    environment = "${var.ec2_environment}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(compact(split(",", var.private_subnets)))}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  count = "${length(compact(split(",", var.public_subnets)))}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
