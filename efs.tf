module "efs" {
  source                   = "./modules/efs"
  aws_tags                 = local.aws_tags
  client_security_group_id = module.eks.worker_security_group_id
  storage_class_name       = "efs-sc"
  subnets                  = module.primary_vpc.private_subnets
  vpc_id                   = module.primary_vpc.vpc_id
  client_iam_role_name     = module.eks.worker_iam_role_name
  namespace                = "kube-system"
}