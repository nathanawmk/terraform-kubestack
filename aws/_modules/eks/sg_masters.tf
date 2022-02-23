resource "aws_security_group" "masters" {
  name        = var.metadata_name
  description = "Cluster communication with worker nodes."
  vpc_id      = aws_vpc.current.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.eks_metadata_tags, {
    yor_trace = "4ed3a66a-4aab-4813-acf5-c61947ecc70c"
  })
}

resource "aws_security_group_rule" "masters_ingress_apiserver_public" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow public internet access to cluster API Server."
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.masters.id
  to_port           = 443
  type              = "ingress"
}
