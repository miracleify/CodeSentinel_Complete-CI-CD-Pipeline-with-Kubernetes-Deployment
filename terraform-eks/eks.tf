resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.33"

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
  }

  # minimal logging optional
  enabled_cluster_log_types = ["api", "audit"]
}

resource "aws_eks_node_group" "ng" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = aws_subnet.public[*].id

  scaling_config {
    desired_size = var.node_desired_capacity
    min_size     = 1
    max_size     = 3
  }

  instance_types = [var.node_instance_type]

  remote_access {
    # left empty because you said no SSH; to enable, set key_name and security group
    # key_name = "your-keypair"
  }

  disk_size = 20

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly
  ]
}
