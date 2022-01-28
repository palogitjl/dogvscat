# Security Groups:

resource "aws_security_group" "ddc" {
  name        = "${var.deployment}_ddc-default"
  description = "Default Security Group for Docker EE"
  vpc_id      = "${local.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # WinRM HTTP & HTTPS remote access - needed for Ansible
  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # best to comment RDP access out after initial deployment testing!
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  timeouts {
    delete = "1h"
  }
  tags = {
    yor_trace = "844f81a8-76dd-4e87-af0a-f4db42ce061b"
  }
}

resource "aws_security_group" "apps" {
  name        = "${var.deployment}_apps-default"
  description = "Default Security Group for Docker EE applications"
  vpc_id      = "${local.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  timeouts {
    delete = "1h"
  }
  tags = {
    yor_trace = "6b9fdece-9421-458a-a31f-4dfe469d438c"
  }
}

resource "aws_security_group" "elb" {
  name        = "${var.deployment}_elb-default"
  description = "Default Security Group for Docker EE ELBs"
  vpc_id      = "${local.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  timeouts {
    delete = "1h"
  }
  tags = {
    yor_trace = "99fd488f-6d44-4cd4-b35f-d4709e13ef25"
  }
}

resource "aws_security_group" "dtr" {
  name        = "${var.deployment}_dtr-default"
  description = "Default Security Group for Docker EE DTR ELB"
  vpc_id      = "${local.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  timeouts {
    delete = "1h"
  }
  tags = {
    yor_trace = "e2865b07-4d9f-40c5-80bf-73f38c3f7f15"
  }
}
