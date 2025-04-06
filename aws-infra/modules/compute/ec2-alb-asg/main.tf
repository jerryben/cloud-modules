# -------------------------
# Security Group for ALB
# -------------------------
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-${var.alb_name}-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = var.vpc_id

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

  tags = {
    Name = "${var.environment}-${var.alb_name}-sg"
  }
}

# -------------------------
# Security Group for EC2
# -------------------------
resource "aws_security_group" "instance_sg" {
  name        = "${var.environment}-ec2-sg"
  description = "Allow HTTP from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.instance_port
    to_port         = var.instance_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ec2-sg"
  }
}

# -------------------------
# Launch Template
# -------------------------
resource "aws_launch_template" "this" {
  name_prefix   = "${var.environment}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = var.environment
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello from Terraform EC2" > /var/www/html/index.html
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
  )
}

# -------------------------
# Application Load Balancer
# -------------------------
resource "aws_lb" "this" {
  name               = "${var.environment}-${var.alb_name}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.alb_subnet_ids

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.environment}-tg"
  port     = var.instance_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# -------------------------
# Auto Scaling Group
# -------------------------
resource "aws_autoscaling_group" "this" {
  name                      = "${var.environment}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.asg_subnet_ids
  target_group_arns         = [aws_lb_target_group.this.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}
