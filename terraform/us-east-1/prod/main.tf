terraform {
  backend "s3" {
    #TODO
    bucket         = "sdp-state-files"
    key            = "state_file_name"
    dynamodb_table = "tf_state"
    region         = "us-east-1"
    encrypt        = true
  }
}
#TODO
data "terraform_remote_state" "global_state" {
  backend = "s3"
  config = {
    bucket         = "sdp-state-files"
    key            = "state_file_name"
    dynamodb_table = "tf_state"
    region         = "us-east-1"
    encrypt        = true
  }
}
