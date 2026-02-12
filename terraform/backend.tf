terraform {
  backend "s3" {
    bucket         = "n8n-eks-terraform-state-20260211143152333400000001"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "n8n-eks-terraform-locks"
    encrypt        = true
  }
}
