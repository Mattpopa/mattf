provider "aws" {
    region = "eu-central-1"
}

resource "aws_db_instance" "wipdb080817" {
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    name = "wipdb080817"
    username = "toor"
    password = "${var.dbs_pass}"
}

