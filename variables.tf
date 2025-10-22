variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "az_count" {
  type    = number
  default = 2
}

variable "domain_name" {
  type    = string
  default = null # e.g. app.example.com
}

variable "acm_certificate_arn" {
  type    = string
  default = null # optional if create_acm = true
}

variable "create_acm" {
  type    = bool
  default = false
}

variable "hosted_zone_id" {
  type    = string
  default = null # if you already know it
}

variable "include_www" {
  type    = bool
  default = false # also validate www.domain
}

variable "lambda_code_bucket" {
  type = string
}

variable "lambda_code_key" {
  type = string
}

variable "lambda_runtime" {
  type    = string
  default = "python3.11"
}

variable "lambda_handler" {
  type    = string
  default = "app.handler"
}

variable "db_engine" {
  type    = string
  default = "aurora-postgresql" # or aurora-mysql
}

variable "db_engine_version" {
  type    = string
  default = "15"
}

variable "db_name" {
  type    = string
  default = "ecomdb"
}

variable "db_username" {
  type    = string
  default = "appuser"
}

variable "db_min_capacity" {
  type    = number
  default = 0.5
}

variable "db_max_capacity" {
  type    = number
  default = 4
}

variable "alarm_email" {
  type    = string
  default = null
}

variable "create_hosted_zone" {
  type    = bool
  default = false
}

variable "domain_zone_name" {
  type    = string
  default = null # apex, e.g. "example.com"
}
