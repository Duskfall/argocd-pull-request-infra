variable "project_dir" {
  default = ""
}

variable "project_name" {
  default = ""
}

variable "ecr_repository_name" {
  default = ""
}

variable "aws_region" {
  default = ""
}

variable "github_owner" {
  default = ""
}

variable "github_token" {
  default   = ""
  sensitive = true
}

variable "github_repo_name_vote" {
  default = ""
}

variable "github_repo_name_infra" {
  default = ""
}
