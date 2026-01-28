# tf-aws-alb-components-module

This module helps create listener, target group, target group attachment, and security group rules for a pre-existing ALB. It uses concepts similar to dependency injection, which means it requires an ALB to already be created before usage.

## Example

This is mostly intended for usage in setting up public-facing ALBs in the central Network account, but it might be usable for private ALBs, as well.

```terraform

# create a SG for the ALB
resource "aws_security_group" "my-sg" {
  name        = "my-sg"
  description = "Allow alb traffic"

  # there are better ways to handle this than hard-coding a string,
  # but for example purposes, this helps highlight that terraform
  # is not responsible for creating this vpc and is merely using
  # a vpc that already exists.
  vpc_id      = "vpc-0841b53d43ace1d4a" 
}

# create the ALB itself outsode of this module, either directly or
# via another module.
resource "aws_lb" "my-alb-nonprod" {
  name               = "my-alb-nonprod"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my-sg.id]
  subnets            = local.ingress_subnet_ids
}

module "my-alb-nonprod-components" {
  source            = "github.com/Tufts-Technology-Services/tf-aws-alb-components-module?ref=v0.0.2"
  vpc_id            = local.ingress_vpc_id
  alb_arn           = aws_lb.my-alb-nonprod.arn
  alb_name          = aws_lb.my-alb-nonprod.name
  alb_cert_arn      = module.my-cert.certificate_arn
  security_group_id = aws_security_group.my-sg.id
  listener_protocol = "HTTPS"
  target_protocol   = "HTTPS"
  source_cidr       = local.all_ips

  # these ips are the private 10.* ips of an NLB in the workload account
  listener_rule_mappings = {
    "app_dev" = {
      description : "app-dev"
      hostname_pattern : ["app-dev.some-team.cloud.tufts.edu"]
      target_ips: ["10.148.a.b", "10.148.c.d", "10.148.e.f"]
    },
    "d1_test" = {
      description : "d1-test"
      hostname_pattern : ["app-test.some-team.cloud.tufts.edu"]
      target_ips : ["10.148.g.h", "10.148.i.j", "10.148.k.l"]
    }
  }
  target_port   = 443
  listener_port = 443

}

```

<!-- markdownlint-disable MD033 MD060 -->
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener.alb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.alb_ip_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.alb_ip_group_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_vpc_security_group_egress_rule.allow_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.allow_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | [external] ARN of an ALB | `string` | n/a | yes |
| <a name="input_alb_cert_arn"></a> [alb\_cert\_arn](#input\_alb\_cert\_arn) | [external] ARN of an ACM cert | `string` | n/a | yes |
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | name of an ALB, used when creating resources like target groups | `string` | n/a | yes |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | n/a | `number` | n/a | yes |
| <a name="input_listener_protocol"></a> [listener\_protocol](#input\_listener\_protocol) | n/a | `string` | n/a | yes |
| <a name="input_listener_rule_mappings"></a> [listener\_rule\_mappings](#input\_listener\_rule\_mappings) | n/a | <pre>map(<br/>    object({<br/>      description      = string,<br/>      hostname_pattern = list(string),<br/>      target_ips       = set(string),<br/>    })<br/>  )</pre> | `{}` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | [external] ID of SG to add rules to allow traffic | `string` | n/a | yes |
| <a name="input_source_cidr"></a> [source\_cidr](#input\_source\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_target_ips"></a> [target\_ips](#input\_target\_ips) | deprecated now that listener rules are in place | `set(string)` | `null` | no |
| <a name="input_target_port"></a> [target\_port](#input\_target\_port) | n/a | `number` | n/a | yes |
| <a name="input_target_protocol"></a> [target\_protocol](#input\_target\_protocol) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | [external] ID of VPC in which to deploy | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_listener_arn"></a> [alb\_listener\_arn](#output\_alb\_listener\_arn) | ARN for created listener |
| <a name="output_map_data"></a> [map\_data](#output\_map\_data) | n/a |
<!-- END_TF_DOCS -->