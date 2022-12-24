variable "project_dir" {
  default = ""
}

variable "project_name" {
  default = ""
}

variable "aws_region" {
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

variable "github_token" {
  default   = ""
  sensitive = true
}
