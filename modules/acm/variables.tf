variable "name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "include_www" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(string)
}
