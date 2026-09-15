resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cicd-ecs-vpc"
  }

}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "cicd-igw"
  }

}

resource "aws_subnet" "public_subnet_1" {

  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.availability_zone_1

}

resource "aws_subnet" "public_subnet_2" {

  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.availability_zone_2

}

resource "aws_subnet" "private_subnet_1" {

  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zone_1

}

resource "aws_subnet" "private_subnet_2" {

  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zone_2

}

resource "aws_route_table" "pub_route" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "cicd-public_route_table"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.pub_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id

}

resource "aws_route_table_association" "public_subnets" {
  for_each = {
    az1 = aws_subnet.public_subnet_1.id
    az2 = aws_subnet.public_subnet_2.id

  }

  subnet_id      = each.value
  route_table_id = aws_route_table.pub_route.id

}

resource "aws_route_table" "priv_route" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "cicd-private-route-table"
  }
}

resource "aws_route_table_association" "private_subnets" {
  for_each = {

    az1 = aws_subnet.private_subnet_1.id
    az2 = aws_subnet.private_subnet_2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.priv_route.id


}


resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.ecs_vpc.id
  service_name        = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.ecs_vpc.id
  service_name        = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.ecs_vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.priv_route.id
  ]
}

resource "aws_vpc_endpoint" "ecs_cloudwatch" {
  vpc_id              = aws_vpc.ecs_vpc.id
  service_name        = "com.amazonaws.us-east-1.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]
}

