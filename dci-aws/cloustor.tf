resource "aws_efs_file_system" "cloudstor-gp" {
  count = "${var.efs_supported}"

  tags {
    Name = "${format("%s-Cloudstor-GP", var.deployment)}"
  }

  performance_mode = "generalPurpose"
  tags = {
    yor_trace = "4a389d94-fad7-4b56-8ed9-69c5a2b42247"
  }
}

resource "aws_efs_file_system" "cloudstor-maxio" {
  count = "${var.efs_supported}"

  tags {
    Name = "${format("%s-Cloudstor-MaxIO", var.deployment)}"
  }

  performance_mode = "maxIO"
  tags = {
    yor_trace = "46ef437f-79e5-415d-9a4b-3982ae9c8f2d"
  }
}

resource "aws_efs_mount_target" "cloudstor-gp" {
  file_system_id  = "${aws_efs_file_system.cloudstor-gp.id}"
  count           = "${var.efs_supported * length(data.aws_availability_zones.available.names)}"
  subnet_id       = "${element(aws_subnet.pubsubnet.*.id, count.index)}"
  security_groups = ["${aws_security_group.ddc.id}"]
}

resource "aws_efs_mount_target" "cloudstor-maxio" {
  file_system_id  = "${aws_efs_file_system.cloudstor-maxio.id}"
  count           = "${var.efs_supported * length(data.aws_availability_zones.available.names)}"
  subnet_id       = "${element(aws_subnet.pubsubnet.*.id, count.index)}"
  security_groups = ["${aws_security_group.ddc.id}"]
}
