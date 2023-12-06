variable "vpc_id" {
  description = "[external] ID of VPC in which to deploy"
  type        = string
}

variable "alb_arn" {
  description = "[external] ARN of an ALB"
  type        = string
}

variable "alb_name" {
  description = "name of an ALB, used when creating resources like target groups"
  type        = string
}

variable "alb_cert_arn" {
  description = "[external] ARN of an ACM cert"
  type        = string
}

variable "security_group_id" {
  type        = string
  description = "[external] ID of SG to add rules to allow traffic"
}

variable "listener_protocol" {
  type = string
}

variable "target_protocol" {
  type = string
}

variable "target_ips" {
  type = set(string)
}

variable "source_cidr" {
  type = string
}

variable "listener_port" {
  type = number
}

variable "target_port" {
  type = number
}
