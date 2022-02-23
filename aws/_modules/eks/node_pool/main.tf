resource "aws_eks_node_group" "nodes" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]
  disk_size      = var.disk_size

  tags = merge(var.eks_metadata_tags, {
    yor_trace = "266689da-2266-454c-a9f4-80f28f672b9d"
  })
  labels = var.metadata_labels

  depends_on = [var.depends-on-aws-auth]
}
