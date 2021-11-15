module "cluster_autoscaler" {
  source               = "./modules/cluster-autoscaler"
  aws_tags             = local.aws_tags
  eks_id               = module.eks.cluster_id
  eks_name             = local.eks_name
  namespace            = "cluster-autoscaler"
  worker_iam_role_name = module.eks.worker_iam_role_name
  aws_region           = var.aws_region
}