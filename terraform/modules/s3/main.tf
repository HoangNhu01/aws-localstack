resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = false # Ngăn chặn xóa bucket khi còn dữ liệu

  #   tags = {
  #     Environment = "Production"
  #     Owner       = "DevOps"
  #   }
}

# Bucket Policy chỉ cho phép truy cập từ IAM Role/VPC cụ thể
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::000000000000:root"] # Thay bằng IAM Role của bạn
    }
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    # condition {
    #   test     = "NotIpAddress"
    #   variable = "aws:SourceIp"
    #   values   = ["10.0.0.0/16"]  # Chỉ cho phép truy cập từ VPC này
    # }
  }
}

resource "aws_s3_bucket_policy" "allow_public" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket_policy.json
  #   policy = jsonencode({
  #     Version = "2012-10-17"
  #     Statement = [
  #       {
  #         Effect    = "Allow"
  #         Principal = "*"
  #         Action    = "s3:GetObject"
  #         Resource  = "${aws_s3_bucket.this.arn}/*"
  #       }
  #     ]
  #   })
}

# Bật versioning để theo dõi các phiên bản object
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Mã hóa dữ liệu bằng SSE-S3 (hoặc SSE-KMS nếu cần)
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # SSE-S3
      # Nếu dùng KMS, thay bằng: sse_algorithm = "aws:kms", kms_master_key_id = "<KMS_KEY_ARN>"
    }
  }
}


# Bật logging truy cập bucket
resource "aws_s3_bucket_logging" "logging" {
  bucket        = aws_s3_bucket.this.id
  target_bucket = aws_s3_bucket.this.id # Thay bằng tên bucket chứa log
  target_prefix = "logs/${aws_s3_bucket.this.id}/"
}

# Lifecycle Policy để chuyển object sang Glacier sau 30 ngày
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "move-to-glacier"
    status = "Enabled"

    filter {
      and {
        prefix = "temp/"
        tags = {
          temp = "true"
        }
      }
    }

    transition {
      days          = 2
      storage_class = "GLACIER"
    }

    # Xóa các object cũ sau 30 ngày
    expiration {
      days = 30
    }
  }
}
# Block mọi truy cập public
# resource "aws_s3_bucket_public_access_block" "block_public" {
#   bucket = aws_s3_bucket.this.id
#   block_public_acls       = true # Chặn việc gán ACL (Access Control List) công khai cho bucket/object.
#   block_public_policy     = true # Chặn các bucket policy cho phép truy cập public.
#   ignore_public_acls      = true # Bỏ qua mọi ACL công khai đã tồn tại trên bucket.
#   restrict_public_buckets = true # Chặn mọi truy cập public ngay cả khi có policy cho phép.
# }

# # (Tùy chọn) Cross-Region Replication (CRR)
# resource "aws_s3_bucket_replication" "replication" {
#   bucket = aws_s3_bucket.this.id
#   role   = aws_iam_role.replication.arn  # Cần tạo IAM Role có quyền replication

#   destination {
#     bucket        = "arn:aws:s3:::my-dr-bucket"  # Bucket ở region khác
#     storage_class = "STANDARD"
#   }
# }
