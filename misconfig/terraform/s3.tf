resource "aws_s3_bucket" "misconfig-s3" {
  bucket = "misconfig-s3"
  tags = {
    Name = "misconfig-s3"
  }
}

resource "aws_s3_bucket_public_access_block" "misconfig-s3" {
  bucket = aws_s3_bucket.misconfig-s3.id
  block_public_acls       = false
  block_public_policy     = false
}

resource "aws_s3_object" "flag_file" {
  bucket = "${aws_s3_bucket.misconfig-s3.bucket}"
  key    = "flag.txt"
  source = "./flag/flag.txt"
  tags = {
    Name = "flag.txt"
  }
}
