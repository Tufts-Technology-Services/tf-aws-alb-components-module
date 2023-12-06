resource "aws_lb_target_group" "alb_ip_tg" {
  name        = "${var.alb_name}-ip-${var.target_port}-tg"
  port        = var.target_port
  protocol    = var.target_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "alb_ip_group_attach" {
  target_group_arn = aws_lb_target_group.alb_ip_tg.arn
  port             = var.target_port

  # If the private IP address is outside of the VPC scope, this value must be set to all
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment#availability_zone
  availability_zone = "all"

  for_each = var.target_ips

  # For target_type = ip, target_id is the IP address
  target_id = each.value

}