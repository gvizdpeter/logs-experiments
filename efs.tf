resource "aws_iam_policy" "efs_csi_controller_policy" {
  name = "EFSCSIControllerIAMPolicy"
  path = "/"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems"
        ],
        Resource : "*"
      },
      {
        Effect : "Allow",
        Action : [
          "elasticfilesystem:CreateAccessPoint"
        ],
        Resource : "*",
        Condition : {
          StringLike : {
            "aws:RequestTag/efs.csi.aws.com/cluster" : "true"
          }
        }
      },
      {
        Effect : "Allow",
        Action : "elasticfilesystem:DeleteAccessPoint",
        Resource : "*",
        Condition : {
          StringEquals : {
            "aws:ResourceTag/efs.csi.aws.com/cluster" : "true"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_efs_csi_controller_policy_attachment" {
  role       = module.eks.worker_iam_role_name
  policy_arn = aws_iam_policy.efs_csi_controller_policy.arn
}

resource "aws_efs_file_system" "eks_efs" {
  creation_token   = "eks-efs"
  performance_mode = "generalPurpose"
  tags             = local.aws_tags
}

resource "aws_efs_mount_target" "eks_efs_mount_target" {
  for_each = toset(module.primary_vpc.private_subnets)

  file_system_id  = aws_efs_file_system.eks_efs.id
  subnet_id       = each.key
  security_groups = [aws_security_group.eks_efs_security_group.id]
}

resource "aws_security_group" "eks_efs_security_group" {
  vpc_id = module.primary_vpc.vpc_id
  name   = "efs-security-group"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = module.primary_vpc.private_subnets_cidr_blocks
  }

  tags = local.aws_tags
}

resource "helm_release" "aws_efs_csi_driver" {
  chart         = "aws-efs-csi-driver"
  repository    = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  name          = "aws-efs-csi-driver"
  version       = "2.2.0"
  recreate_pods = true
  namespace     = "kube-system"

  values = [
    templatefile("${path.module}/helm-values/aws-efs-csi-driver.yaml", {
      efs_id = aws_efs_file_system.eks_efs.id
    })
  ]
}