provider "aws" {
    region = "eu-central-1"
}

variable "server_port" {
    description = "HTTP port"
    default = 9090
    }

resource "aws_instance" "wip-020817" {
    ami = "ami-1e339e71"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
            #!/bin/bash
            echo "..." > index.html
            nohup busybox httpd -f -p "${var.server_port}" &
            EOF
    tags {
    Name = "wip-020817m"
    }
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

output "public_ip" {
    value = "${aws_instance.wip-020817.public_ip}"
    }

