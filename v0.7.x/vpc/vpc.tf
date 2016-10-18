resource "aws_vpc" "vpc" {
  cidr_block = "${var.global["vpc_cidr"]}"
  enable_dns_hostnames = "${var.global["enable_dns_hostnames"]}"
  enable_dns_support = "${var.global["enable_dns_support"]}"
  tags { 
    Name = "${var.global["name"]}"
    environment = "${var.global["ec2_environment"]}"
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags { 
    Name = "${var.global["vpc_name"]}-public"
    environment = "${var.global["environment"]}"
  }
}

resource "aws_route" "public_internet_gateway" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc.id}"
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(split(",", var.global["public_sub"]), count.index)}"
  availability_zone = "${element(split(",", var.global["availability_zones"]), count.index)}"
  count = "${length(compact(split(",", var.global["public_sub"])))}"
  tags { 
    Name = "${var.global["vpc_name"]}-public"
    environment = "${var.global["environment"]}"
  }
  map_public_ip_on_launch = true
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags { 
    Name = "${var.global["vpc_name"]}-private"
    environment = "${var.global["environment"]}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(split(",", var.global["private_sub"]), count.index)}"
  availability_zone = "${element(split(",", var.global["availability_zones"]), count.index)}"
  count = "${length(compact(split(",", var.global["private_sub"])))}"
  tags { 
    Name = "${var.global["vpc_name"]}-private"
    environment = "${var.global["environment"]}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(compact(split(",", var.global["private_sub"])))}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  count = "${length(compact(split(",", var.global["public_sub"])))}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
