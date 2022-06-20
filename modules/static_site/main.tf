resource "aws_s3_bucket" "site" {
  bucket_prefix = "site"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# No hace falta encriptar el static sita. Ademas, controlamos el acceso mediante el OAI.
# No hace falta loguear por ya (deberiamos) loguear a nivel Cloudfront. Sino se repetirian los accesos.