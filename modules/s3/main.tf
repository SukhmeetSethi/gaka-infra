# KMS Key for S3 bucket encryption
resource "aws_kms_key" "s3_bucket_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name        = "gaka-s3-kms-key-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# KMS Key Alias
resource "aws_kms_alias" "s3_bucket_key_alias" {
  name          = "alias/gaka-s3-kms-key-${var.environment}"
  target_key_id = aws_kms_key.s3_bucket_key.key_id
}

# S3 Bucket Resource
# tfsec:ignore:aws-s3-enable-bucket-logging
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

# Enable server-side encryption with KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "gaka_kr_encryption" {
  bucket = aws_s3_bucket.gaka_kr.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_bucket_key.arn
      sse_algorithm     = "aws:kms"
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