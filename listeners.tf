resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = var.alb_arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  certificate_arn   = var.alb_cert_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Your ALB is working.  You'll need to ensure you're passing enough info to create some listener rules for actions. "
      status_code  = "200"
    }
  }

}
