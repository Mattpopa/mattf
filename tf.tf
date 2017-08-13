terraform {
  backend "s3" {
    bucket  = "wip-tf-state-080817"
    key     = "wip-tf-state"
    region  = "eu-central-1"
    encrypt = true
    profile = "cyclones-dev"
  }
}
