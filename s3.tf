
# S3 Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-log-bucket-task1" 

  # For versioning
  versioning {
    enabled = true
  }

  #for configure logging (for access logs)
  logging {
    target_bucket = "my-log-bucket-task1" 
    target_prefix = "logs/"
  }

  tags = {
    Name        = "LogBucket"
    Environment = "Production"
  }
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  bucket = aws_s3_bucket.log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "aws_s3_bucket" {
  value = aws_s3_bucket.log_bucket.bucket
}

