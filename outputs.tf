output "ec2_sg_id" {
  value = "${aws_security_group.webstack-ec2-sg.id}"
}

output "ec2_role_id" {
  value = "${aws_iam_role.ec2_role.id}"
}

output "alb_sg_id" {
  value = "${element(concat(aws_security_group.ec2_alb.*.id, list("")), 0)}"
}
/*
output "lb_dns_name" {
  value = "${aws_lb.ec2_alb.dns_name}"
}*/

output "webstack_ami" {
  value = "${aws_launch_template.lt.image_id}"
}