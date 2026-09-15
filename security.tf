resource "aws_security_group" "alb_sg_cicd" {

  name        = "alb-sg-pipline"
  description = "allow HTTP traffic from the internet"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-SG-Pipeline"
  }

}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg-cicd"
  description = "allow traffic from ALB-SG"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg_cicd.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "ECS-SG-Pipeline"
  }
}

resource "aws_security_group" "endpoint_sg" {
  name        = "ecr_sg-cicd"
  description = "allow traffic from ECS Task"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "ECR-SG-Pipeline"
  }
}

moved {
  from = aws_security_group.ECS_SG
  to   = aws_security_group.ecs_sg
}

