variable "namespace" {
  type = string
}

variable "logstash_namespace" {
  type = string
}

variable "logstash_service_name" {
  type = string
}

variable "logstash_beats_port" {
  type = number
}

variable "graylog_namespace" {
  type = string
}

variable "graylog_beats_services" {
  type = list(string)
}

variable "graylog_beats_port" {
  type = number
}

variable "chart_version" {
  type    = string
  default = "7.10.2"
}