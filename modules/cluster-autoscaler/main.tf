resource "aws_iam_role_policy_attachment" "workers_autoscaling" {
  policy_arn = aws_iam_policy.worker_autoscaling.arn
  role       = var.worker_iam_role_name
}

resource "aws_iam_policy" "worker_autoscaling" {
  name_prefix = "eks-worker-autoscaling-${var.eks_id}"
  policy      = data.aws_iam_policy_document.worker_autoscaling.json
  path        = "/"
  tags        = var.aws_tags
}

data "aws_iam_policy_document" "worker_autoscaling" {
  statement {
    sid    = "eksWorkerAutoscalingAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerAutoscalingOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${var.eks_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}

resource "helm_release" "cluster_autoscaler" {
  chart            = "cluster-autoscaler"
  repository       = "https://kubernetes.github.io/autoscaler"
  name             = "cluster-autoscaler"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  recreate_pods    = true

  values = [
    templatefile("${path.module}/helm-values/cluster-autoscaler.yaml", {
      aws_region = var.aws_region
      eks_name   = var.eks_name
    })
  ]
}