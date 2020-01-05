resource "aws_s3_bucket" "aws-sa-2019-bucket" {
  bucket = "aws-sa-2019-bucket-sambird"
  region = "us-east-1"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "aws-sa-2019-bucket-with-versioning" {
  bucket = "aws-sa-2019-bucket-sambird-versioning-enabled"
  region = "us-east-1"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_kms_key" "s3" {
  description             = "This key is used to encrypt S3 bucket objects"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "s3-alias" {
  name          = "alias/s3-bucket-kms-alias"
  target_key_id = aws_kms_key.s3.key_id
}

