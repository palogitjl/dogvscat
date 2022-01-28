# Create the stack VPC
resource "aws_vpc" "docker" {
  count                = "${local.create_vpc}"
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "${format("%s-vpc", "${var.deployment}")}"
    yor_trace = "88bc20f6-baa5-4500-9de7-71b7093acbb2"
  }
}

locals {
  create_vpc = "${length(var.vpc_id) == 0 ? 1 : 0}"
  vpc_id     = "${local.create_vpc ? join("", aws_vpc.docker.*.id) : var.vpc_id}"
}

# Create the associated subnet - Need to loop based on Count of AZ
# CIDR block mapping from vars
resource "aws_subnet" "pubsubnet" {
  vpc_id = "${local.vpc_id}"
  count  = "${length("${data.aws_availability_zones.available.names}")}"

  cidr_block              = "${cidrsubnet("${var.vpc_cidr}", 4, count.index)}"
  map_public_ip_on_launch = true
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = {
    Name      = "${format("%s-Subnet-%d", "${var.deployment}", count.index + 1)}"
    yor_trace = "cd9e55b1-d4bf-4e38-9e68-67442334f786"
  }
}

## Public route table association
resource "aws_route_table_association" "public" {
  count          = "${length("${data.aws_availability_zones.available.names}") * local.create_vpc}"
  subnet_id      = "${element(aws_subnet.pubsubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_igw.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${local.vpc_id}"
  count  = "${local.create_vpc}"

  tags {
    Name = "InternetGateway"
  }
  tags = {
    yor_trace = "e680ea99-ee32-4c34-b5b2-b0fff6a8cbcd"
  }
}

resource "aws_route_table" "public_igw" {
  vpc_id = "${local.vpc_id}"
  count  = "${local.create_vpc}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${format("%s-rt", "${var.deployment}")}"
  }
  tags = {
    yor_trace = "cbac3b67-aa7d-4d78-bf4c-1bea8515c6b5"
  }
}

resource "aws_route" "internet_access" {
  count                  = "${local.create_vpc}"
  route_table_id         = "${aws_route_table.public_igw.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"

  timeouts {
    create = "15m"
  }
}
