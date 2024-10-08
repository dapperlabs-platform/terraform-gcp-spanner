terraform {
  required_version = ">= 1.3.8"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0"
    }
  }
}
