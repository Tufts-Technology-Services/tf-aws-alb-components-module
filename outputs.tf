output "alb_listener_arn" {
  value       = aws_lb_listener.alb_listener.arn
  description = "ARN for created listener"
}

output "map_data" {
  value = local.map_data
}