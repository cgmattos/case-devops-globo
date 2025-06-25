variable "project_id" {
  default = "cg-case-globo"
  type        = string
}

variable region {
  type        = string
  default     = "southamerica-east1"
  description = "Região do projeto"
}

variable zone {
  type        = string
  default     = "southamerica-east1-c"
  description = "Zona do projeto"
}

variable "bucket_name" {
  default = "cg-case-globo"
  type        = string
}

variable "bucket_location" {
  type        = string
  default     = "SOUTHAMERICA-EAST1"
}