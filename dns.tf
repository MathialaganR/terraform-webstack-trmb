#--------------------------------------------------------------
# Host Record
#--------------------------------------------------------------

resource "aws_route53_record" "ec2_alb" {
  count   = "${var.enable_alb ? 1 : 0}"
  zone_id = "${var.global_phz_id}"
  name    = "${var.ec2_alb_cname}"
  type    = "A"

  alias {
    name                   = "${aws_lb.ec2_alb.dns_name}"
    zone_id                = "${aws_lb.ec2_alb.zone_id}"
    evaluate_target_health = true
  }
}
