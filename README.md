# Logs experiments

`cp .env.dist .env` and fill in required variables

Change `backend.tf` file to your s3 bucket

Terraform resources must be created by targeting `terraform apply -target=`:
1. `module.primary_vpc`
2. `module.eks`
3. `module.cilium`
4. `module.efs`
5. `module.cluster_autoscaler`
6. `module.elasticsearch`

Then `terraform apply` without target can be used
