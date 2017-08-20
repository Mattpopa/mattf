output "entry_point" {
    value = "${module.webcluster.elb_dns_name}"
}

