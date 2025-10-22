variable "name" { type = string }
variable "create" { type = bool }
variable "zone_name" { type = string } # dominio raíz, por ej. example.com
variable "tags" { type = map(string) }