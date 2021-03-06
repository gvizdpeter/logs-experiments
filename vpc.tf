module "primary_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.11.0"

  name = "primary-vpc"
  cidr = "192.168.0.0/16"

  azs             = data.aws_availability_zones.available.names
  public_subnets  = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  private_subnets = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true

  tags = local.aws_tags
}