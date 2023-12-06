output "target_group_arn" {
  value       = aws_lb_target_group.alb_ip_tg.arn
  description = "ARN for the created target group"
}

output "alb_listener_arn" {
  value       = aws_lb_listener.alb_listener.arn
  description = "ARN for created listener"
}