resource "aws_ecs_cluster" "main" {
  name = "services-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "fargate" {
  name              = "fargate"
  retention_in_days = 1
}

// TODO(tobi): Healthcheck
# TODO(tobi): Acceder al ECR por la red interna
resource "aws_ecs_task_definition" "main" {
  for_each = var.services

  family = each.key
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name        = "${each.key}-container"
    image       = lookup(var.service_images, each.key, "invalid")
    essential   = true
    environment = var.environment

    portMappings = [{
      protocol      = "tcp"
      containerPort = 80
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.fargate.id,
        awslogs-region        = var.logs_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

# Nota: Ideal hacer el service descovery con esto, pero no tenemos permisos :(((
resource "aws_ecs_service" "main" {
  for_each = var.services

  name                               = "${each.key}-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main[each.key].arn
  desired_count                      = 3
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.app_subnets
    assign_public_ip = false
  }
  
  load_balancer {
    target_group_arn = var.public_alb_target_groups[each.key].arn
    container_name   = "${each.key}-container"
    container_port   = 80
  }

  load_balancer {
    target_group_arn = var.internal_alb_target_groups[each.key].arn
    container_name   = "${each.key}-container"
    container_port   = 80
  }
  
  # Con el autoescalado este valor va a cambiar. No queremos que esto afecte la infraestructura.
  lifecycle {
    ignore_changes = [desired_count]
  }
}

