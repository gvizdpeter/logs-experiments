resource "aws_iam_policy" "efs_csi_controller_policy" {
  name = "EFSCSIControllerIAMPolicy"
  path = "/"

  policy = file("${path.module}/aws/iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "eks_cluster_efs_csi_controller_policy_attachment" {
  role       = var.client_iam_role_name
  policy_arn = aws_iam_policy.efs_csi_controller_policy.arn
}

resource "aws_efs_file_system" "eks_efs" {
  creation_token   = "eks-efs"
  performance_mode = "generalPurpose"
  tags             = var.aws_tags
}

resource "aws_efs_mount_target" "eks_efs_mount_target" {
  for_each = toset(var.subnets)

  file_system_id  = aws_efs_file_system.eks_efs.id
  subnet_id       = each.key
  security_groups = [aws_security_group.eks_efs_security_group.id]
}

resource "aws_security_group" "eks_efs_security_group" {
  vpc_id = var.vpc_id
  name   = "efs-security-group"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    security_groups = [var.client_security_group_id]
  }

  tags = var.aws_tags
}

resource "helm_release" "aws_efs_csi_driver" {
  chart         = "aws-efs-csi-driver"
  repository    = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  name          = "aws-efs-csi-driver"
  version       = var.chart_version
  recreate_pods = true
  namespace     = var.namespace

  values = [
    templatefile("${path.module}/helm-values/aws-efs-csi-driver.yaml", {
      efs_id             = aws_efs_file_system.eks_efs.id
      storage_class_name = var.storage_class_name
    })
  ]
}