resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/cicd-pipeline-app"
  retention_in_days = 7

  tags = {
    Name = "cicd-pipeline-logs"
  }

}