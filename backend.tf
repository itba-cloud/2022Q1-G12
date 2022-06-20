terraform {
  backend "s3" {
    key     = "state"
    encrypt = true
  }
}
