# S3 Bucket Resource
resource "aws_s3_bucket" "gaka_kr" {
  bucket = "gaka-kr-${var.environment}"

  tags = {
    Name        = "gaka-kr-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "gaka_kr_versioning" {
  bucket = aws_s3_bucket.gaka_kr.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "gaka_kr_encryption" {
  bucket = aws_s3_bucket.gaka_kr.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "gaka_kr_public_access" {
  bucket = aws_s3_bucket.gaka_kr.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
} 