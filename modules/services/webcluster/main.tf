data "aws_availability_zones" "all" {}

data "terraform_remote_state" "dbs" {
  backend = "s3"
  environment = "${terraform.env}"
  config {
    bucket  = "wip-tf-state-080817"
    key     = "dbs"
    region  = "eu-central-1"
    encrypt = true
    profile = "cyclones-dev"
  }
}

data "template_file" "user_data" {
    template = "${file("../../../modules/services/webcluster/user_data.sh")}"

        vars {
            server_port = "${var.server_port}"
            db_address = "${data.terraform_remote_state.dbs.address}"
            db_port = "${data.terraform_remote_state.dbs.port}"
        }
}

resource "aws_launch_configuration" "wip-020817" {
    image_id = "ami-1e339e71"
    instance_type = "t2.micro"
    key_name = "mpopa"
    security_groups = ["${aws_security_group.instance.id}", "${aws_security_group.instance2.id}"]

    #user_data = "${file("user_data.sh")}"
    user_data = "${data.template_file.user_data.rendered}"

   lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "instance" {
    name = "wip-020817"
    ingress {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "instance2" {
    name = "wip-170817"
    ingress {
        from_port = "${var.server_port2}"
        to_port = "${var.server_port2}"
        protocol = "tcp"
        cidr_blocks = ["78.96.101.50/32", "109.166.0.0/16"]
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "wip-020817" {
    launch_configuration = "${aws_launch_configuration.wip-020817.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    
    load_balancers = ["${aws_elb.wip-elb.name}"]
    health_check_type = "ELB"

    min_size = 2 
    max_size = 5

    tag {
        key = "Name"
        value = "wip-asg-060817"
        propagate_at_launch = true
    }
}

resource "aws_elb" "wip-elb" {
    name = "wip-020817"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    security_groups = ["${aws_security_group.elb.id}"]    
    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = "${var.server_port}"
        instance_protocol = "http"
    }
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        interval = 30
        target = "HTTP:${var.server_port}/"
    }
}

resource "aws_security_group" "elb" {
    name = "wip-elb"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}
