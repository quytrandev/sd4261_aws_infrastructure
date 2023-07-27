resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "eks" {
  key_name_prefix = "${var.name}-${var.environment}"
  public_key      = tls_private_key.this.public_key_openssh

  tags = module.tags_dev.tags
}
