resource "google_project_service" "apis" {
  for_each = toset([
    "containerregistry.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com"
  ])
  
  project = var.project_id
  service = each.value
  
  disable_dependent_services = false
}

resource "google_redis_instance" "redis" {
    name          = "case-globo-cache"
    project       = var.project_id
    tier          = "BASIC"
    location_id   = var.zone
    authorized_network = var.redis_vpc
    memory_size_gb = 1
}

resource "google_artifact_registry_repository" "registry" {
  repository_id = var.registry_name
  location      = var.region
  project       = var.project_id
  format        = "DOCKER"
  description   = "Repositório de imagens Docker ${var.registry_name}"
  
  depends_on = [google_project_service.apis]
}

resource "null_resource" "docker_login" {
    provisioner "local-exec" {
        interpreter = ["/bin/bash" ,"-c"]
        command = "docker login -u _json_key --password-stdin https://${var.region}-docker.pkg.dev/${var.registry_name} < files/access-key.json"
    }
    depends_on = [ google_artifact_registry_repository.registry ]
}

resource "null_resource" "build_and_push_images" {
  for_each = var.services  
  provisioner "local-exec" {
    interpreter = ["/bin/bash" ,"-c"]
    command = <<EOT
      docker build \
        -t ${var.region}-docker.pkg.dev/${var.project_id}/${var.registry_name}/${each.key}:${var.image_tag} \
        ${each.value.build_context}
      docker push ${var.region}-docker.pkg.dev/${var.project_id}/${var.registry_name}/${each.key}:${var.image_tag}
    EOT
  }
  
  depends_on = [ null_resource.docker_login ]
}

resource "google_cloud_run_service" "services" {
  for_each = var.services
  name     = each.key
  location = var.region
  project  = var.project_id

  template {
    metadata {
      annotations = merge(
        {
          "autoscaling.knative.dev/maxScale" = tostring(each.value.max_scale)
          "autoscaling.knative.dev/minScale" = tostring(each.value.min_scale)
          "run.googleapis.com/client-name"   = "terraform"
          "run.googleapis.com/vpc-access-connector" = var.redis_connector
          "run.googleapis.com/vpc-access-egress"    = "ALL_TRAFFIC"
        },
        lookup(each.value, "annotations", {})
      )
    }
    
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.registry_name}/${each.key}:${var.image_tag}"
        
        resources {
          limits = {
            cpu    = each.value.cpu
            memory = each.value.memory
          }
        }
        
        dynamic "env" {
          for_each = lookup(each.value, "env_vars", {})
          content {
            name  = env.key
            value = env.value
          }
        }
        
        ports {
          container_port = each.value.port
        }
      }
      
      timeout_seconds = lookup(each.value, "timeout", 300)
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    null_resource.build_and_push_images,
    google_project_service.apis,
    google_redis_instance.redis,
  ]
  
  lifecycle {
    ignore_changes = [
      template[0].metadata[0].annotations["run.googleapis.com/operation-id"],
    ]
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {
  for_each = {
    for k, v in var.services : k => v
    if lookup(v, "allow_public_access", false)
  }
  
  service  = google_cloud_run_service.services[each.key].name
  location = google_cloud_run_service.services[each.key].location
  project  = var.project_id
  role     = "roles/run.invoker"
  member   = "allUsers"
}