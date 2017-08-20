provider "aws" {
    region = "eu-central-1"
}
module "dbs" {
    source = "../../../modules/dbs/mysql"
    dbs_pass = "{var.dbs_pass}"
}
