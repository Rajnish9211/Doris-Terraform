terraform {
  backend "s3" {
    bucket         = "dev-doris-bucket"
    key            = "doris/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "doris-table"
    encrypt        = true
  }
}