module "network" {
  source         = "./vpc"
  vpc_cidr       = "10.0.0.0/16"
  public_subnet  = "10.0.1.0/24"
  private_subnet = "10.0.2.0/24"
}

module "security" {
  source            = "./security"
  vpc_id            = module.network.vpc_id
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
}

data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

module "ec2" {
  source         = "./ec2"
  public_ami_id  = "ami-0bdd0d71e3c47a3ff" # your custom public AMI
  private_ami_id = "ami-00ca32bbc84273381" # Amazon Linux 2023 AMI
  instance_type  = "t2.micro"
  public_subnet  = module.network.public_subnet_id
  private_subnet = module.network.private_subnet_id
  sg_id          = module.security.sg_id
}

