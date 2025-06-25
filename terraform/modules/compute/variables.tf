variable "project_id" {}

variable "region" {}

variable "zone" {}

variable "registry_name" {}

variable "image_tag" {}

variable "redis_vpc" {}

variable "redis_connector" {}

variable "services" {
  description = "Configuração para cada App"
  type = map(object({
    build_context       = string
    dockerfile_path     = optional(string, "Dockerfile")
    build_args         = optional(map(string), {}) 
    platform           = optional(string, "linux/amd64")
    port               = optional(number, 80)
    cpu                = optional(string, "1000m")
    memory             = optional(string, "512Mi")
    min_scale          = optional(number, 1)
    max_scale          = optional(number, 3)
    timeout            = optional(number, 300)
    env_vars           = optional(map(string), {})
    annotations        = optional(map(string), {})
    allow_public_access = optional(bool, false)
    custom_domain      = optional(string, null)
    service_account    = optional(string, null)
  }))
}