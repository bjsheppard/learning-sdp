resource "aws_ecs_task_definition" "service" {
  family                = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 256,
    "image": "service-first",
    "memory": 512,
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

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
        "Service": "ecs.amazonaws.com"
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

resource "aws_lb" "dev_ecs_alb" {
  name               = "tdev-ecs-alb"
  internal           = true
  load_balancer_type = "application"
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
  vpc_id   = var.vpc-id
}

resource "aws_ecs_cluster" "ecs_dev_cluster" {
  name = "ecs-dev-cluster"
}

resource "aws_ecs_service" "dev_ecs_service" {
  name            = "dev-ecs-cluster"
  cluster         = aws_ecs_cluster.ecs_dev_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 2
  iam_role        = aws_iam_role.dev_ecs_role.arn
  launch_type     = "FARGATE"

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.dev_ecs_service.arn
    container_name   = "service"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}