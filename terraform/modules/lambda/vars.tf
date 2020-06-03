variable "environment" {
  type = string
}

variable "filename" {
  type = string
}

variable "template_file_rendered" {
  type = string
}

variable "function_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "publish" {
  default = true
}

variable "description" {
  type = string
}

variable "log_retention_days" {
  default     = "7"
  description = "No. of days to keep lambda cloudwatch log messages"
}