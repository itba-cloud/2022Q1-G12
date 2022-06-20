resource "aws_ecr_repository" "main" {
  for_each = var.services
  name = each.key
}

resource "aws_ecr_lifecycle_policy" "main" {
  for_each = toset([for k, v in aws_ecr_repository.main : v.name])
  repository = each.key
 
  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 10 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 10
     }
   }]
  })
}

resource "docker_registry_image" "services" {
  for_each = var.services

  # Obligatorio que se llamen como su registry. Un registry por imagen :c
  name = "${aws_ecr_repository.main[each.key].repository_url}:${each.value.version}"

  build {
      context = "${path.cwd}/${var.services_location}/${each.key}"
  }  
}
