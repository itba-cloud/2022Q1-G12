output "service_images" {
  description = "Images of services to deploy"
  value       = { for service, definition in var.services : service => docker_registry_image.services[service].name }
}