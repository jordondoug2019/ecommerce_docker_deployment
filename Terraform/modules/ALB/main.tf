
# Create Security Group for the Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  vpc_id     = var.production_vpc
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  # Egress (outbound) rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# Create Target Group for the Load Balancer
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.production_vpc

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
}



resource "aws_lb" "load_balancer" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

# Create Listener for Load Balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

# Register EC2 Instances to the Target Group
resource "aws_lb_target_group_attachment" "instance1" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = var.app_az1_id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "instance2" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = var.app_az2_id
  port             = 3000
}