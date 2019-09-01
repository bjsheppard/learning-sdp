

#######################################################################################
#                 IAM Role/Policy/Attachment/Profile                                  #
#######################################################################################
# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html       #
# Creates the IAM Role and Assume Policy used by Lambda functions #
#######################################################################################

resource "aws_iam_role" "dev_ecs_role" {
  name = "dev-ecs-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com",
          "lambda.amazonaws.com",
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# https://www.terraform.io/docs/providers/aws/r/iam_policy.html
# Policy used by ASGs to post lifecycle events to SNS
resource "aws_iam_policy" "dev_ecs_policy" {
  name        = "dev-ecs-policy"
  description = "Dev ECS Policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "*",
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "dev_ecs_policy_attach" {
    name       = "dev-ecs-policy-attach"
    roles       = [aws_iam_role.dev_ecs_role.name]
    policy_arn = aws_iam_policy.dev_ecs_policy.arn
}

# resource "aws_iam_policy_attachment" "aws_ecs_policy_attach" {
#     name       = "aws-ecs-policy-attach"
#     roles       = [aws_iam_role.dev_ecs_role.name]
#     policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
# }

resource "aws_lb" "dev_ecs_alb" {
  name               = "tdev-ecs-alb"
  internal           = true
  security_groups    = [aws_security_group.jenkins_sg.id]
  subnets            = [var.dev_subnet_AZ1, var.dev_subnet_AZ2]

  tags = {
    Environment = "dev-ecs-cluster"
  }
}

resource "aws_lb_target_group" "dev_ecs_service" {
  name     = "dev-ecs-lb-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc-id
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.dev_ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

 default_action {
    target_group_arn = aws_lb_target_group.dev_ecs_service.arn
    type             = "forward"
  } 
}

resource "aws_ecs_task_definition" "service" {
  family                = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.dev_ecs_role.arn
  execution_role_arn       = "arn:aws:iam::069855360696:role/ecsTaskExecutionRole"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 256,
    "image": "069855360696.dkr.ecr.us-east-1.amazonaws.com/nginx:latest",
    "memory": 512,
    "name": "service",
    "essential": true,
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp",
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_cluster" "ecs_dev_cluster" {
  name = "ecs-dev-cluster"
}

resource "aws_ecs_service" "dev_ecs_service" {
  name            = "dev-ecs-cluster"
  cluster         = aws_ecs_cluster.ecs_dev_cluster.arn
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.jenkins_sg.id]
    subnets         = [var.dev_subnet_AZ1, var.dev_subnet_AZ2]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.dev_ecs_service.arn
    container_name   = "service"
    container_port   = 80
  }
}