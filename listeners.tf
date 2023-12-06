resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = var.alb_arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  certificate_arn   = var.alb_cert_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_ip_tg.arn
  }
}
