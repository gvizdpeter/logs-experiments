module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 17.23.0"

  cluster_version = "1.21"
  cluster_name    = "elk"
  vpc_id          = module.primary_vpc.vpc_id
  subnets         = module.primary_vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  write_kubeconfig                = false

  cluster_tags = local.aws_tags

  node_groups = {
    elk_group = {
      desired_capacity = 3
      max_capacity     = 6
      min_capacity     = 3
      disk_size        = 20

      instance_types  = ["t3.medium"]
      k8s_labels      = local.aws_tags
      additional_tags = local.aws_tags
    }
  }
}

resource "local_file" "kubeconfig" {
  filename = "${path.module}/kube/config"
  content  = module.eks.kubeconfig
}

resource "null_resource" "delete_aws_cni" {
  triggers = {
    eks_id = module.eks.cluster_id
  }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${local.eks_config_path} delete daemonset -n kube-system aws-node"
  }
}

resource "helm_release" "cilium" {
  chart         = "cilium"
  repository    = "https://helm.cilium.io/"
  name          = "cilium"
  version       = "1.10.5"
  recreate_pods = true
  namespace     = "kube-system"

  values = [file("${path.module}/helm-values/cilium.yaml")]

  depends_on = [
    null_resource.delete_aws_cni,
  ]
}
