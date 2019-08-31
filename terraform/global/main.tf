provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    #TODO
    bucket         = "state_bucket_name"
    key            = "state_file_name"
    dynamodb_table = "dynamo_db_table"
    region         = "update_region"
    encrypt        = true
  }
}

