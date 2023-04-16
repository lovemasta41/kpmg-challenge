# ##### Application Load Balancer - Internal 
resource "aws_lb" "app_alb" {
  name               = "${local.vpc_name}-app-lb"
  internal           = false
  load_balancer_type = "application"

  subnets            = [for idx, subnet in aws_subnet.private_subnet : idx < 2 ? subnet.id : ""]
  security_groups    = [aws_security_group.app_sg.id]

  tags = merge(
    local.tags,
    { "Name" = "${local.vpc_name}-app-lb" }
  )
}

resource "aws_lb_target_group" "app_lb_target_group" {
  name_prefix       = "apptg"
  port              = 443
  protocol          = "HTTPS"
  vpc_id            = aws_vpc.new_vpc.id

  target_type = "instance"
}

resource "aws_autoscaling_attachment" "app_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  alb_target_group_arn   = aws_lb_target_group.app_lb_target_group.arn
}

resource "aws_lb_listener" "app_https" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "target_group_rule" {
  listener_arn = aws_lb_listener.app_https.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }

  condition {
    path_pattern {
        values = ["/login/*"] 
    }
  }
}

