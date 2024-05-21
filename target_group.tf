resource "aws_lb_target_group" "alb_ip_tg" {
  for_each = var.listener_rule_mappings

  name        = "${var.alb_name}-${var.target_port}-${each.value.description}"
  port        = var.target_port
  protocol    = var.target_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id
}


locals {
  map_data = flatten([
    for key, m in var.listener_rule_mappings : [
      for team, ip in m.target_ips : {
        env       = key
        single_ip = ip
      }
    ]
  ])
}

resource "aws_lb_target_group_attachment" "alb_ip_group_attach" {
  for_each = {
    for tm in local.map_data : "${tm.env}-${tm.single_ip}" => tm
  }

  target_group_arn = aws_lb_target_group.alb_ip_tg[each.value.env].arn
  port             = var.target_port

  # If the private IP address is outside of the VPC scope, this value must be set to all
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment#availability_zone
  availability_zone = "all"


  # For target_type = ip, target_id is the IP address
  target_id = each.value.single_ip
}

resource "aws_lb_listener_rule" "listener_rule" {
  for_each     = var.listener_rule_mappings
  listener_arn = aws_lb_listener.alb_listener.arn
  #priority     = each.value.priority


  action {
    type = "forward"
    //target_group_arn = aws_alb_target_group.alb_ip_tg[each.key].arn
    target_group_arn = aws_lb_target_group.alb_ip_tg[each.key].arn
  }

  condition {
    host_header {
      values = each.value.hostname_pattern
    }
  }
}
