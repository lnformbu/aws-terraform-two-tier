terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.66, < 5.67.0"
    }

  }

  # using terraform cloud for my local test run backend.
  cloud {
    organization = "AWS-100DaysofDevOps"
    workspaces {
      name = "100DaysDevOps"
    }
  }

}


provider "aws" {
  region = "us-east-1" # Change this to your preferred AWS region
}