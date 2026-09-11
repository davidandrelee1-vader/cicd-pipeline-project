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

