# Making a task definition

resource "aws_ecs_task_definition" "app" {
  family                   = "cicd-pipeline-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "cicd-pipeline-app"

      image = "${aws_ecr_repository.jenkins.repository_url}:1.3"

      portMappings = [
        {
          containerPort = 5000
        }
      ]
    }
  ])
}

#MAKING ECS Cluster

resource "aws_ecs_cluster" "cluster_app" {
  name = "cicd-pipeline-cluster"

}

resource "aws_ecs_service" "service_app" {
  name            = "cicd-pipeline-service"
  cluster         = aws_ecs_cluster.cluster_app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

}