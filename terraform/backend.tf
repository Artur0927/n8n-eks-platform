# Remote state backend — uncomment after running bootstrap/
# Replace the bucket name with the output from: cd bootstrap && terraform output s3_bucket_name
#
# terraform {
#   backend "s3" {
#     bucket         = "YOUR_BUCKET_NAME_HERE"
#     key            = "terraform/state"
#     region         = "us-east-1"            # Must match your var.region
#     dynamodb_table = "n8n-eks-terraform-locks"
#     encrypt        = true
#   }
# }
