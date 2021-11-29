variable "app_count" {
  type = number
  default = 1
}

variable "ecs_cluster" {
  type = string
}

variable "app_docker_tag" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}