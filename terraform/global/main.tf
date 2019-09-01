provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "sdp-state-files"
    key            = "global_state"
    dynamodb_table = "tf_state"
    region         = "us-east-1"
    encrypt        = true
  }
}

