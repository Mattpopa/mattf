provider "aws" {
    region = "eu-central-1"
}

module "webcluster" {
    source = "../../../modules/services/webcluster"
    cluster_name = "stage"
}

