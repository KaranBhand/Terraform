resource aws_s3_bucket mybucket {
	bucket = "karanbahndawss3bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
