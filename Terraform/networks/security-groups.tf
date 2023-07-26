resource "aws_security_group" "alb_ingress" {
  name        = "alb-ingress"
  description = "Allow public traffic"
  vpc_id      = module.network_dev.vpc.id

  ingress {
    description = "allow incoming 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow incoming 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    module.network_label_dev.tags,
    {
      Name = "alb-ingress-${var.project-name}-${var.name}-dev"
    }
  )
}