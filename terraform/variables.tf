variable "project_id" {
  type        = string
  default     = "cg-case-globo"
  description = "ID do projeto da GCP"
}

variable "region" {
  type        = string
  default     = "southamerica-east1"
  description = "Região do projeto"
}

variable "zone" {
  type        = string
  default     = "southamerica-east1-c"
  description = "Zona do projeto"
}

variable "path_python_app" {
  type    = string
  default = "python-hello-globo"
}

variable "path_golang_app" {
  type    = string
  default = "golang-hello-globo"
}

variable "registry_name" {
  type    = string
  default = "cg-case-globo"
}

variable "vpc_name" {
  type    = string
  default = "case-globo-vpc"
}

variable "subnet_name" {
  type    = string
  default = "case-globo-subnet"
}

variable "subnet_cidr" {
  type    = string
  default = "10.100.0.0/24"
}

variable "connector_cidr" {
  type    = string
  default = "10.102.0.0/28"
}
