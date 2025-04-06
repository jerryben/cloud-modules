# EC2 module to launch instances and register with ALB target group

resource "aws_instance" "app" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.private_subnet_ids, count.index % length(var.private_subnet_ids))
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_name

  user_data = var.user_data != "" ? var.user_data : null

  tags = {
    Name        = "${var.name}-app-${count.index}"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.name}-app-sg"
  description = "SG for application EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-app-sg"
  }
}

resource "aws_lb_target_group_attachment" "app_attachment" {
  count            = var.instance_count
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
}
