variable "name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "domain_name" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}