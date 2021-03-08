#---------------------------------------------------------------
# Create EC2 ALB
#---------------------------------------------------------------

resource "aws_lb" "ec2_alb" {
  internal                   = "${var.elb_internal}"
  load_balancer_type         = "application"
  name                       = "${var.global_product}-${var.global_environment}-${var.ec2_role}-alb"
  subnets                    = "${split(",", var.alb_subnets)}"
  security_groups            = ["${aws_security_group.ec2_alb.id}"]
  enable_deletion_protection = "false"
  idle_timeout               = "400"

  tags {
    Name            = "${var.global_product}-${var.global_environment}-${var.ec2_role}-alb"
    "Product"       = "${var.tag_product}"
    "Environment"   = "${var.global_environment}"
    "Contact"       = "${var.global_contact}"
    "CostCode"      = "${var.global_costcode}"
    "Role"          = "${var.ec2_role}"
    "Orchestration" = "${var.orchestration}"
    "Service"       = "${var.deployed_service}"
  }
}

# ---------------------------------
# LISTENERS
# ---------------------------------

resource "aws_alb_listener" "internal443" {
  load_balancer_arn = "${aws_lb.ec2_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.ssl_cert_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.internal_8080_target_group.arn}"
    type             = "forward"
  }
}

# ---------------------------------
# TARGET GROUP
# ---------------------------------

resource "aws_alb_target_group" "internal_8080_target_group" {
  name     = "alb-int-target-group8080-${var.global_environment}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.global_vpc_id}"

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "5"
    enabled         = "${var.enable_alb}"
  }

  health_check {
    protocol            = "HTTP"
    interval            = "30"
    path                = "/"
    healthy_threshold   = "2"
    unhealthy_threshold = "4"
    timeout             = "10"
    matcher             = "200,302"
  }

  tags {
    Name          = "${var.global_product}-${var.global_environment}-internal-target-group"
    Product       = "${var.tag_product}"
    Environment   = "${var.global_environment}"
    Contact       = "${var.global_contact}"
    CostCode      = "${var.global_costcode}"
    Orchestration = "${var.orchestration}"
    "Service"     = "${var.deployed_service}"
  }
}

# ---------------------------------
# TARGET GROUP ATTACHMENTS
# ---------------------------------

resource "aws_autoscaling_attachment" "internal8080" {
  alb_target_group_arn   = "${aws_alb_target_group.internal_8080_target_group.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.asg.id}"
}
