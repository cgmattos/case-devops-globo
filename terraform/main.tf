terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.41.0"
    }
  }
  backend "gcs" {
    bucket      = "cg-case-globo"
    prefix      = "terraform/state"
    credentials = "files/access-key.json"
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("files/access-key.json")
  zone        = var.zone
}

module "network" {
  source = "./modules/network"

  project_id     = var.project_id
  region         = var.region
  vpc_name       = var.vpc_name
  subnet_name    = var.subnet_name
  subnet_cidr    = var.subnet_cidr
  connector_cidr = var.connector_cidr
}

module "compute" {
  source = "./modules/compute"

  project_id      = var.project_id
  region          = var.region
  registry_name   = var.registry_name
  zone            = var.zone
  image_tag       = "latest"
  redis_vpc       = module.network.vpc_id
  redis_connector = module.network.vpc_connector_id

  services = {
    python_app = {
      build_context = "../${var.path_python_app}"
      port          = 80
      cpu           = "1000m"
      memory        = "512Mi"
      min_scale     = 1
      max_scale     = 1
      env_vars = {
        REDIS_HOST           = module.compute.redis_host
        REDIS_PORT           = module.compute.redis_port
        REDIS_DB             = "0"
        DEBUG_MODE           = "False"
        PORT                 = "80"
        HOST                 = "0.0.0.0"
        CACHE_WINDOW_SECONDS = "10"
        CACHE_KEY            = "python_app"
      }
      allow_public_access = true
    }

    golang_app = {
      build_context   = "../${var.path_golang_app}"
      dockerfile_path = "Dockerfile"
      port            = 80
      cpu             = "1000m"
      memory          = "512Mi"
      min_scale       = 1
      max_scale       = 1
      env_vars = {
        PORT           = "80"
        HOST           = "0.0.0.0"
        DEBUG          = "True"
        REDIS_URL      = "${module.compute.redis_host}:${module.compute.redis_port}"
        REDIS_PASSWORD = ""
        REDIS_DB       = "0"
        CACHE_KEY      = "golang-app"
        CACHE_TIMEOUT  = "60"
      }
      allow_public_access = true
    }
  }
}

