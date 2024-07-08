terraform {
  backend "s3" {
    bucket = "bucket_name" // bucket name
    key    = "file_path_in_Bucket" //bucket path in bucket
    region = "us-east-2" #region name
    dynamodb_table = "terraform-locks"  # Replace with your DynamoDB table name
    encrypt       = true // encryption
  }
}