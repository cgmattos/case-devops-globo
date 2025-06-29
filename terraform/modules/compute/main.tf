resource "google_redis_instance" "redis" {
  name               = "case-globo-cache"
  project            = var.project_id
  tier               = "BASIC"
  location_id        = var.zone
  authorized_network = var.redis_vpc
  memory_size_gb     = 1
}

resource "google_artifact_registry_repository" "registry" {
  repository_id = var.registry_name
  location      = var.region
  project       = var.project_id
  format        = "DOCKER"
  description   = "Repositório de imagens Docker ${var.registry_name}"
}

resource "null_resource" "build_and_push_images" {
  for_each = var.services

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      docker login -u _json_key --password-stdin https://${var.region}-docker.pkg.dev/${var.registry_name} < files/access-key.json
      docker build \
        -t ${var.region}-docker.pkg.dev/${var.project_id}/${var.registry_name}/${each.key}:${var.image_tag} \
        ${each.value.build_context}
      docker push ${var.region}-docker.pkg.dev/${var.project_id}/${var.registry_name}/${each.key}:${var.image_tag}
    EOT
  }

  depends_on = [google_artifact_registry_repository.registry]
}

resource "google_cloud_run_service" "services" {
  for_each = var.services
  name     = each.value.app_name
  location = var.region
  project  = var.project_id

  template {
    metadata {
      annotations = merge(
        {
          "terraform.redeploy.timestamp" = timestamp() 
          "autoscaling.knative.dev/maxScale"        = tostring(each.value.max_scale)
          "autoscaling.knative.dev/minScale"        = tostring(each.value.min_scale)
          "run.googleapis.com/client-name"          = "terraform"
          "run.googleapis.com/vpc-access-connector" = var.redis_connector
          "run.googleapis.com/vpc-access-egress"    = "all-traffic"
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

  depends_on = [ google_cloud_run_service.services ]
}
