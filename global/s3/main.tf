provider "aws" {
    region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "wip-tf-state-080817"
    versioning {
        enabled = true
    }
    lifecycle {
        prevent_destroy = true
    }
}

