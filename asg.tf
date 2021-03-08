#---------------------------------------------------------------
# Autoscaling Group
#---------------------------------------------------------------
resource "aws_autoscaling_group" "asg" {
  name                      = "${var.global_product}.${var.global_environment}.${var.ec2_role}.asg"
  vpc_zone_identifier       = ["${split(",", var.alb_subnets)}"]
  #launch_configuration      = "${aws_launch_configuration.lc.id}"
  max_size                  = "1"
  min_size                  = "1"
  health_check_type         = "EC2"
  target_group_arns         = ["${aws_alb_target_group.internal_8080_target_group.id}"]
  health_check_grace_period = "300"

  launch_template  {
    id      = "${aws_launch_template.lt.id}"
    version = "$$Latest"
  }

  tag {
    key                 = "SubProduct"
    value               = "${var.tag_product}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "${var.ec2_role}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Product"
    value               = "${var.tag_product}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Orchestration"
    value               = "${var.orchestration}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.global_product}.${var.global_environment}.${var.ec2_role}.scaled_instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.global_environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "CostCode"
    value               = "${var.global_costcode}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Contact"
    value               = "${var.global_contact}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Service"
    value               = "${var.deployed_service}"
    propagate_at_launch = true
  }
}


#---------------------------------------------------------------
# Autoscaling Launch Template
#---------------------------------------------------------------

resource "aws_launch_template" "lt" {
  name_prefix          = "${var.global_product}.${var.global_environment}.${var.ec2_role}.lt"
  image_id             = "${var.ec2_ami}"
  instance_type        = "${var.ec2_instance_type}"
  key_name             = "${var.global_key_name}"


  network_interfaces {
    delete_on_termination       = "true"
    security_groups             = ["${list(aws_security_group.webstack-ec2-sg.id)}"]
    associate_public_ip_address = "false"
  }

  iam_instance_profile
  {
    name = "${aws_iam_instance_profile.ec2_profile.id}"
  }

  lifecycle {
    create_before_destroy = true
  }


  #user_data = "${element(data.template_file.userdata.*.rendered, count.index)}"
  user_data = "${base64encode(data.template_file.userdata.rendered)}"

}

#-----------------------------------------------------------------
# User data rendered
#-----------------------------------------------------------------
data "template_file" "userdata" {

  count    = "${var.ec2_count}"
  template = "${file("${var.ec2_user_data}")}"

  vars {
    #appliedhostname   = "${var.ec2_hostrecord}}"
    appliedhostname   = "${var.ec2_hostrecord}${format("%03d", count.index + 1 + var.hostname_offset)}"
    product           = "${var.tag_product}"
    environment       = "${var.global_environment}"
    role              = "${var.ec2_role}"

  }
}
