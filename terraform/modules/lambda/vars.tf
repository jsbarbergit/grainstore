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
