terraform {
  required_version = "~> 1.2.0"

  backend "s3" {
    key     = "state"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.1"
    }
  }
}
