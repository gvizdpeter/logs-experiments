variable "zone_id" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "ttl" {
  type    = string
  default = "300"
}