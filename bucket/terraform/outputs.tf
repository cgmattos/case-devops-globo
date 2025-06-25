output "bucket_name" {
  description = "The name of the created bucket"
  value       = google_storage_bucket.main_bucket.name
}

output "bucket_url" {
  description = "The URL of the created bucket"
  value       = google_storage_bucket.main_bucket.url
}

output "bucket_self_link" {
  description = "The self link of the created bucket"
  value       = google_storage_bucket.main_bucket.self_link
}