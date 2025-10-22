variable "name" {
  type = string
}

variable "api_id" {
  type = string
}

variable "alarm_email" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}