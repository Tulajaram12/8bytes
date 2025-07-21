terraform {
  backend "s3" {
    bucket         = "8bytes-terraform-state-bucket"
    key            = "envs/staging/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

