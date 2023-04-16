# ##### Application Load Balancer - External
resource "aws_lb" "web_alb" {
  name               = "${local.vpc_name}-web-lb"
  internal           = false
  load_balancer_type = "application"

  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  security_groups    = [aws_security_group.web_sg.id]

  tags = merge(
    local.tags,
    { "Name" = "${local.vpc_name}-web-lb" }
  )
}

resource "aws_lb_target_group" "web_lb_target_group" {
  name_prefix       = "webtg"
  port              = 443
  protocol          = "HTTPS"
  vpc_id            = aws_vpc.new_vpc.id

  target_type = "instance"
}

resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  alb_target_group_arn   = aws_lb_target_group.web_lb_target_group.arn
}

resource "aws_lb_listener" "web_https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    target_group_arn = aws_lb_target_group.web_lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "web_target_group_rule" {
  listener_arn = aws_lb_listener.web_https.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_lb_target_group.arn
  }

  condition {
    host_header {
      values = ["bank.awsemea.com"]
    }
  }
}

