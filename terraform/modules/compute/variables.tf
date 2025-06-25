variable "project_id" {
    description = "ID do projeto"
}

variable "region" {
    description = "Região do projeto"
}

variable "zone" {
    description = "Zona do projeto"
}

variable "registry_name" {
    description = "Nome do registry utilizado pelo Cloud Run"
}

variable "image_tag" {
    description = "Tag das imagens utilizadas no Cloud Run"
}

variable "redis_vpc" {
    description = "Variável com o nome da VPC criada para conexão do Redis com o Cloud Run"
}

variable "redis_connector" {
    description = "Connector criado para permitir acesso do Cloud Run à VPC do Redis através do backend da GCP"
}

variable "services" {
  description = "Configuração para cada App"
  type = map(object({
    app_name = string
    build_context       = string
    dockerfile_path     = optional(string, "Dockerfile")
    build_args          = optional(map(string), {})
    platform            = optional(string, "linux/amd64")
    port                = optional(number, 80)
    cpu                 = optional(string, "1000m")
    memory              = optional(string, "512Mi")
    min_scale           = optional(number, 1)
    max_scale           = optional(number, 3)
    timeout             = optional(number, 300)
    env_vars            = optional(map(string), {})
    annotations         = optional(map(string), {})
    allow_public_access = optional(bool, false)
    custom_domain       = optional(string, null)
    service_account     = optional(string, null)
  }))
}