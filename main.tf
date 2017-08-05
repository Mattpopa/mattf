provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "wip-020817" {
    ami = "ami-1e339e71"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

user_data = <<-EOF
            #!/bin/bash
            echo "..." > index.html
            nohup busybox httpd -f -p 9090 &
            EOF
tags {
    Name = "wip-020817m"
    }
}
resource "aws_security_group" "instance" {
    name = "wip-020817"
    
    ingress {
        from_port = 9090
        to_port = 9090
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
