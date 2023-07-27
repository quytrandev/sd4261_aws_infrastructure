resource "aws_security_group" "this" {
  for_each    = var.security-groups
  name        = each.key
  vpc_id      = aws_vpc.vpc.id
  description = "Instance default security group"
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each          = { for k,v in var.security-groups : k => v if lookup(v, "egress", null) != null }
  security_group_id = aws_security_group.this[each.key].id

  cidr_ipv4   = lookup(each.value.egress, "cidr_blocks", null)
  from_port   = lookup(each.value.egress, "from_port", null)
  ip_protocol = lookup(each.value.egress, "protocol", null)
  to_port     = lookup(each.value.egress, "to_port", null)
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each          = { for k,v in var.security-groups : k => v if lookup(v, "ingress", null) != null}
  security_group_id = aws_security_group.this[each.key].id

  cidr_ipv4   = lookup(each.value.ingress, "cidr_blocks", null)
  from_port   = lookup(each.value.ingress, "from_port", null)
  ip_protocol = lookup(each.value.ingress, "protocol", null)
  to_port     = lookup(each.value.ingress, "to_port", null)
}
