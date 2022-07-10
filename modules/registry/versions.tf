# Necesitamos esto para que terraform no se confunda con hashicorp/docker
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}
