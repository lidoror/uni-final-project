module "app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "${var.resource_alias}-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available_azs_ids.zone_ids
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = false

  tags = {
    Name        = "${var.resource_alias}-vpc"
    Env         = terraform.workspace
    Terraform   = true
  }
}

//Hosted Nodes
module "ec2_instance_ado_workers" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
//to add more workers just strings for the foreach
  for_each = toset(["node1","node2"])

  name = "${var.resource_alias}-ADO-${each.key}"

  ami                    = data.aws_ami.amazon_linux_ami.id
  instance_type          = data.aws_ec2_instance_type_offering.ec2_instance_type.id
  key_name               = data.aws_key_pair.servers_key.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ADO_sg_nodes.id]
  subnet_id              = module.app_vpc.public_subnets[0]

  root_block_device = [{
    volume_type = "gp2"
    volume_size = 30

  }]


  tags = {
    Terraform   = "true"
    App = "Azure-Devops-Node"
  }
}