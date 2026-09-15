output "ecr_repository_url" {
  value = aws_ecr_repository.jenkins.repository_url
}

output "public_subnet_1_id" {
  description = "get the public subnet 1 id"
  value       = aws_subnet.public_subnet_1.id

}

output "public_subnet_2_id" {
  description = "get the public subnet 2 id"
  value       = aws_subnet.public_subnet_2.id

}

output "private_subnet_1_id" {
  description = "get the private subnet 1 id"
  value       = aws_subnet.private_subnet_1.id

}

output "private_subnet_2_id" {
  description = "get the private subnet 2 id"
  value       = aws_subnet.private_subnet_2.id

}

output "alb_security_group_id" {
  description = "the alb security group id"
  value       = aws_security_group.alb_sg_cicd.id

}

output "ecs_security_group_id" {
  description = "the ecs security group id"
  value       = aws_security_group.ecs_sg.id

}

output "ecr_security_group_id" {
  description = "the ecr security group id"
  value       = aws_security_group.endpoint_sg.id

}