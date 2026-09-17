resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/cicd-pipeline-app"
  retention_in_days = 7

  tags = {
    Name = "cicd-pipeline-logs"
  }

}

resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "cicd-pipeline-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # WIDGET 1 - ECS TARGET HEALTH
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "ECS Target Health"
          view   = "timeSeries"
          region = "us-east-1"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "TargetGroup",
              aws_lb_target_group.ecs_tg.arn_suffix,
              "LoadBalancer",
              aws_lb.ecs_alb.arn_suffix
            ],
            [
              "AWS/ApplicationELB",
              "UnHealthyHostCount",
              "TargetGroup",
              aws_lb_target_group.ecs_tg.arn_suffix,
              "LoadBalancer",
              aws_lb.ecs_alb.arn_suffix
            ]
          ]
        }
      },

      # WIDGET 2 - ALB REQUEST COUNT
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "ALB Request Count"
          view   = "timeSeries"
          region = "us-east-1"

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              aws_lb.ecs_alb.arn_suffix
            ]
          ]
        }
      },

      # WIDGET 3 - TARGET RESPONSE TIME
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "Target Response Time"
          view   = "timeSeries"
          region = "us-east-1"

          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "TargetGroup",
              aws_lb_target_group.ecs_tg.arn_suffix,
              "LoadBalancer",
              aws_lb.ecs_alb.arn_suffix
            ]
          ]
        }
      },

      # WIDGET 4 - ECS CPU AND MEMORY
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "ECS CPU and Memory Utilization"
          view   = "timeSeries"
          region = "us-east-1"

          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              aws_ecs_cluster.cluster_app.name,
              "ServiceName",
              aws_ecs_service.service_app.name
            ],
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              aws_ecs_cluster.cluster_app.name,
              "ServiceName",
              aws_ecs_service.service_app.name
            ]
          ]
        }
      }

    ]
  })
}