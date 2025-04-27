resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_http" {
  name        = "${var.app_name}-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
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
}

resource "aws_ecs_cluster" "this" {
  name = "${var.app_name}-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-ecsTaskExecutionRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.app_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-container",
      image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repository_name}:${var.ecr_image_tag}",
      essential = true,
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.allow_http.id]
    assign_public_ip = true
  }
}
