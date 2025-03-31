module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
}

module "security_group" {
  source              = "./modules/security-groups"
  ec2_sg_name         = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  vpc_id              = module.networking.out_vpc_id
}

module "ELK_stack" {
  source                    = "./modules/ec2"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "elk"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.out_public_subnets)[0]
  sg                        = [module.security_group.out_ssh_http_id]
  enable_public_ip_address  = true
  user_data                 = templatefile("./modules/ec2/elk_stack.sh", {})
  root_volume_size          = 25  # Setting root volume size to 25GB
  root_volume_type          = "gp2" # Setting volume type to General Purpose SSD
}

module "App" {
  source                    = "./modules/ec2"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "app"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.out_public_subnets)[0]
  sg                        = [module.security_group.out_ssh_http_id]
  enable_public_ip_address  = true
  user_data                 = templatefile("./modules/ec2/app.sh", {})
  root_volume_size          = 25  # Setting root volume size to 25GB
  root_volume_type          = "gp2" # Setting volume type to General Purpose SSD
}
