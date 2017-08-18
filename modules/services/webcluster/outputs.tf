output "elb_dns_name" {
    value = "${aws_elb.wip-elb.dns_name}"
}
