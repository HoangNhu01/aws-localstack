# Tạo CloudFront Origin Access Control (OAC) cho private S3 bucket
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "my-oac"
  description                       = "Access control for CloudFront to access S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  # Origin 1 - bucket A
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = "bucket-a"
    # origin_access_control_id = aws_cloudfront_origin_access_control.oac.id 
  }

  #   # Origin 2 - bucket B
  #   origin {
  #     domain_name = aws_s3_bucket.bucket_b.bucket_regional_domain_name
  #     origin_id   = "bucket-b"
  #     # origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  #   }

  # Cache behavior cho /images/* 
  ordered_cache_behavior {
    path_pattern           = "images/*"
    target_origin_id       = "bucket-a"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  #   # Cache behavior cho /videos/* 
  #   ordered_cache_behavior {
  #     path_pattern     = "videos/*"
  #     target_origin_id = "bucket-b"
  #     viewer_protocol_policy = "redirect-to-https"

  #     allowed_methods  = ["GET", "HEAD"]
  #     cached_methods   = ["GET", "HEAD"]
  #     forwarded_values {
  #       query_string = false
  #       cookies {
  #         forward = "none"
  #       }
  #     }
  #   }

  # Mặc định route về bucket A
  default_cache_behavior {
    target_origin_id       = "bucket-a"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    # Không giới hạn địa lý nào cả, người dùng từ mọi quốc gia đều có thể truy cập nội dung qua CloudFront.
    geo_restriction {
      restriction_type = "none"
    }
  }
}
