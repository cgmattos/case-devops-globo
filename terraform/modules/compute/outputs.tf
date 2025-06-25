output "redis_host" {
  value = google_redis_instance.redis.host
}

output "redis_port" {
  value = google_redis_instance.redis.port
}

output "service_urls" {
  value = {
    for service_name, svc in google_cloud_run_service.services :
    service_name => svc.status[0].url
  }
}