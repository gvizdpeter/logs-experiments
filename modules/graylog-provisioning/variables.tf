variable "graylog_host" {
  type = string
}

variable "graylog_username" {
  type      = string
  sensitive = true
}

variable "graylog_password" {
  type      = string
  sensitive = true
}

variable "api_version" {
  type    = string
  default = "v4"
}

variable "beats_port" {
  type = number
}