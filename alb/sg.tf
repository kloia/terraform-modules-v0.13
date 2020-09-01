resource "aws_security_group" "sg-alb" {
  name = "${var.name}-sg-alb"
  description = "Allow TLS inbound traffic from all internet."
  vpc_id      = data.aws_vpc.alb_vpc.id
  count       = !var.internal && length(var.security_groups) == 0 && var.create_alb ? 1 : 0

  ingress {
    description = "TLS from all internet"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = merge(var.tags, map("Name", "${var.name}-sg-alb"))
}

resource "aws_security_group" "sg-alb-int" {
  name = "${var.name}-sg-alb-int"
  description = "Allow TLS inbound traffic from VPC."
  vpc_id      = data.aws_vpc.alb_vpc.id
  count       = var.internal && length(var.security_groups) == 0 && var.create_alb ? 1 : 0

  ingress {
    description = "TLS from VPC"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.alb_vpc.cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = merge(var.tags, map("Name", "${var.name}-sg-alb"))
}