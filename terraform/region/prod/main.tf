terraform {
  backend "s3" {
    #TODO
    bucket         = "state_bucket_name"
    key            = "state_file_name"
    dynamodb_table = "dynamodb_table_name"
    region         = "add_region"
    encrypt        = true
  }
}
#TODO
data "terraform_remote_state" "global_state_name" {
  backend = "s3"
  config = {
    bucket         = "state_bucket_name"
    key            = "state_file_name"
    dynamodb_table = "dynamodb_table_name"
    region         = "add_region"
    encrypt        = true
  }
}
