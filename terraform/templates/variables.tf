variable "project_dir" {
  default = ""
}

variable "project_name" {
  default = ""
}

variable "ecr_repository_name" {
  default = ""
}

variable "github_repo_url_infra" {
  default = ""
}

variable "aws_region" {
  default = ""
}

variable "github_owner" {
  default = ""
}

variable "github_repo_name_vote" {
  default = ""
}

variable "aws_access_key_id" {
  default   = ""
  sensitive = true
}

variable "aws_secret_access_key" {
  default   = ""
  sensitive = true
}