# ELBs:

resource "aws_elb" "ucp" {
  name = "${var.deployment}-ucp"

  security_groups = [
    "${aws_security_group.elb.id}",
  ]

  subnets = ["${aws_subnet.pubsubnet.*.id}"]

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 6443
    instance_protocol = "tcp"
    lb_port           = 6443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    target              = "TCP:443"
    interval            = 30
  }

  instances                 = ["${aws_instance.ucp_manager_linux.*.id}"]
  idle_timeout              = 240
  cross_zone_load_balancing = true
  depends_on                = ["aws_internet_gateway.igw"]
  tags = {
    yor_trace = "509f2eab-ca3c-4545-b17b-811c856057c4"
  }
}

resource "aws_elb" "apps" {
  name = "${var.deployment}-apps"

  security_groups = [
    "${aws_security_group.apps.id}",
  ]

  subnets = ["${aws_subnet.pubsubnet.*.id}"]

  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 8000
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    target              = "TCP:443"
    interval            = 30
  }

  instances                 = ["${aws_instance.ucp_worker_linux.*.id}"]
  cross_zone_load_balancing = true
  depends_on                = ["aws_internet_gateway.igw"]
  tags = {
    yor_trace = "20032774-f946-4f06-83b0-2c7d5703ec9d"
  }
}

resource "aws_elb" "dtr" {
  name = "${var.deployment}-dtr"

  security_groups = [
    "${aws_security_group.dtr.id}",
  ]

  subnets = ["${aws_subnet.pubsubnet.*.id}"]

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    target              = "TCP:443"
    interval            = 30
  }

  instances                 = ["${aws_instance.ucp_worker_dtr.*.id}"]
  idle_timeout              = 240
  cross_zone_load_balancing = true
  depends_on                = ["aws_internet_gateway.igw"]
  tags = {
    yor_trace = "ffee855a-f36d-45ed-85cc-75f042b6b45d"
  }
}
