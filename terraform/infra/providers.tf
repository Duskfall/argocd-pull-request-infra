terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest
    aws = {
      source = "hashicorp/aws"
      # >= 4.41.0 <5           version = "~> 55.0.0

    }

    # https://registry.terraform.io/providers/hashicorp/local/latest
    local = {
      source = "hashicorp/local"
      # >= 2.2.0 <3.0.0
      version = "~> 2.2"
    }

    # https://registry.terraform.io/providers/hashicorp/tls/latest
    tls = {
      source = "hashicorp/tls"
      # >= 4.0.0 <5.0.0
      version = "~> 4.0"
    }

    # https://registry.terraform.io/providers/hashicorp/null/latest
    null = {
      source = "hashicorp/null"
      # >= 3.1.0 <4.0.0
      version = "~> 3.1"
    }

    # https://registry.terraform.io/providers/integrations/github/latest
    github = {
      source = "integrations/github"
      # >= 5.2.0 <6.0.0
      version = "~> 5.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# https://registry.terraform.io/providers/integrations/github/latest/docs
provider "github" {
  owner = var.github_owner
  token = var.github_token
}
