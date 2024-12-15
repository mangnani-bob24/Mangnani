resource "aws_s3_bucket" "sensitive_data_bucket" {
  bucket        = "sensitive-data-bucket-2024-war"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# S3 퍼블릭 액세스 블록 설정 추가
resource "aws_s3_bucket_public_access_block" "sensitive_data_block" {
  bucket                  = aws_s3_bucket.sensitive_data_bucket.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# S3 버킷 정책 설정
resource "aws_s3_bucket_policy" "sensitive_data_policy" {
  bucket = aws_s3_bucket.sensitive_data_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "arn:aws:s3:::sensitive-data-bucket-2024-war/*"
    }]
  })
  depends_on = [aws_s3_bucket_public_access_block.sensitive_data_block]
}

# 힌트 파일 업로드
resource "null_resource" "upload_hint_file" {
  provisioner "local-exec" {
    command = <<EOT
      aws s3 cp ./s3_files/hint.txt s3://sensitive-data-bucket-2024-war/hint.txt
    EOT
  }

  triggers = {
    always_run = timestamp() # 리소스를 변경할 때마다 실행
  }

  depends_on = [
    aws_s3_bucket.sensitive_data_bucket,
    aws_s3_bucket_public_access_block.sensitive_data_block,
    aws_s3_bucket_policy.sensitive_data_policy
  ]
}

# S3 버킷 삭제를 위한 클린업
resource "null_resource" "cleanup" {
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      echo "Deleting S3 bucket contents and the bucket itself..."
      aws s3 rm s3://sensitive-data-bucket-2024-war --recursive || echo "Bucket contents not found or already deleted."
      aws s3api delete-bucket --bucket sensitive-data-bucket-2024-war || echo "Bucket not found or already deleted."
    EOT
  }

  depends_on = [
    aws_s3_bucket.sensitive_data_bucket,
    aws_s3_bucket_policy.sensitive_data_policy
  ]
}