
resource "aws_launch_configuration" "web-server-lc" {
  name                        = "web-server"
  image_id                    = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  user_data                   = data.template_file.user-data.rendered
  key_name                    = "devacc2"
  associate_public_ip_address = true
  security_groups             = [data.aws_security_group.available-sg.id]
}

resource "aws_lb" "web-lb" {
  name               = "web-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.available-sg.id]
  subnets            = data.aws_subnets.available-subnets.ids

  enable_deletion_protection = false
  /* 
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  } */

  tags = {
    Environment = "Dev"
  }
}

resource "aws_lb_target_group" "web-alb-target" {
  name        = "web-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.available-vpc.id
}
/* 
resource "aws_lb_target_group_attachment" "tg_attachment" {
    target_group_arn = aws_lb_target_group.web-alb-target.arn
    # target to attach to this target group
    target_id        = aws_lb.web-lb.arn
    #  If the target type is alb, the targeted Application Load Balancer must have at least one listener whose port matches the target group port.
    port             = 80
}
 */
resource "aws_lb_listener" "web-alb-listener" {
  load_balancer_arn = aws_lb.web-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-alb-target.arn
  }
}

resource "aws_autoscaling_group" "web-asg" {
  name                 = "web-asg"
  vpc_zone_identifier  = data.aws_subnets.available-subnets.ids
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.web-server-lc.name
  target_group_arns     = [aws_lb_target_group.web-alb-target.arn]
  tag {
    key                 = "Name"
    value               = "webapp-server-wordpress"
    propagate_at_launch = true
  }
  depends_on = [
    aws_lb_target_group.web-alb-target
  ]
}