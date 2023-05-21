region_to_deploy = "us-west-2"
resource_alias = "lidorort"
instance_key_tag = "lidoror"
vpc_cidr = "10.0.0.0/16"
vpc_private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
ec2_instance_type = ["t2.medium","t3.medium"]