resource "aws_s3_bucket" "misconfig_s3_terraform" {
  bucket = "misconfig-s3-terraform"
  tags = {
    Name = "Misconfig-S3-terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "misconfig_s3_terraform" {
  bucket = aws_s3_bucket.misconfig_s3_terraform.id
  block_public_acls       = false
  block_public_policy     = false
}

resource "aws_s3_object" "flag_file_terraform" {
  bucket = "${aws_s3_bucket.misconfig_s3_terraform.bucket}"
  key    = "flag.txt"
  source = "../flag/flag.txt"
  tags = {
    Name = "flag.txt"
  }
}
