#--------------------------------------------------------------
# Security Groups
#--------------------------------------------------------------
resource "aws_security_group" "webstack-ec2-sg" {
  name        = "${var.global_product}.${var.global_environment}.${var.ec2_role}-sg"
  description = "Security group for ${var.global_product}.${var.global_environment}.${var.ec2_role}-sg"
  vpc_id      = "${var.global_vpc_id}"

  tags {
    Name          = "${var.global_product}.${var.global_environment}.${var.ec2_role}-sg"
    "Product"     = "${var.tag_product}"
    "environment" = "${var.global_environment}"
    "contact"     = "${var.global_contact}"
    "Service" = "${var.deployed_service}"
  }
}

resource "aws_security_group_rule" "SSH_from" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.webstack-ec2-sg.id}"
  cidr_blocks       = ["${split(",", var.cidr_blocks)}"]
}

resource "aws_security_group_rule" "web_port" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = "${aws_security_group.webstack-ec2-sg.id}"
  cidr_blocks       = ["${split(",", var.cidr_blocks)}"]
}



resource "aws_security_group_rule" "lb_listener" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.webstack-ec2-sg.id}"
  source_security_group_id = "${aws_security_group.ec2_alb.id}"
}


# Authorize all outbound traffic.
resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.webstack-ec2-sg.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ALB Security Group
resource "aws_security_group" "ec2_alb" {
  count       = "${var.enable_alb ? 1 : 0}"
  name        = "${var.global_product}.${var.global_environment}.${var.ec2_role}.ec2.alb.sg"
  description = "EC2 ${var.ec2_role} ALB SG"
  vpc_id      = "${var.global_vpc_id}"

  tags {
    "Product"       = "${var.tag_product}"
    "Environment"   = "${var.global_environment}"
    "Contact"       = "${var.global_contact}"
    "CostCode"      = "${var.global_costcode}"
    "Role"          = "${var.ec2_role}"
    "Orchestration" = "${var.orchestration}"
    "Service" =  "${var.deployed_service}"
  }
}

resource "aws_security_group_rule" "alb_access" {
  count             = "${var.enable_alb ? 1 : 0}"
  type              = "ingress"
  from_port         = "${var.listener_lb_port}"
  to_port           = "${var.listener_lb_port}"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.ec2_alb.id}"
  cidr_blocks       = ["${split(",", var.alb_cidr_blocks)}"]
}

resource "aws_security_group_rule" "ec2_outbound" {
  count             = "${var.enable_alb ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.ec2_alb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_to_app_http" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.webstack-ec2-sg.id}"
  source_security_group_id = "${aws_security_group.ec2_alb.id}"
}
