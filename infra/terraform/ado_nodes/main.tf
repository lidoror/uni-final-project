
provider "aws" {
  region = var.region_to_deploy
}


//S3 BUCKET
resource "aws_s3_bucket" "dev_bucket_1" {
  bucket = "${var.resource_alias}-${terraform.workspace}"
  tags = {
    Terraform = "true"
    Creator = var.resource_alias
    Env = terraform.workspace
  }
}

resource "aws_s3_bucket_versioning" "dev_bucket_versioning" {
  bucket = aws_s3_bucket.dev_bucket_1.id
  versioning_configuration {
    status = "Enabled"
  }
}

//SECURITY GROUPS

resource "aws_security_group" "ADO_sg_nodes" {
  name = "ADO_sg-workers"
  vpc_id = module.app_vpc.vpc_id

  ingress {
    description = "SSH"
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Terraform = "true"
    Instance = "Azure-DevOps-node-sg"
  }
}




resource "aws_iam_role" "ado_node_role" {
  name = "${var.resource_alias}-ado-role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
  tags = {
    Name: "${var.resource_alias}-ado-role"
    Terraform: "true"
  }
}

resource "aws_iam_role_policy_attachment" "ado_role_policy_attachment" {
  policy_arn = aws_iam_policy.node_policy.arn
  role       = aws_iam_role.ado_node_role.name

}

resource "aws_iam_instance_profile" "ado_instance_profile" {
  name = "${var.resource_alias}-ado-master-instance-profile"
  role =  aws_iam_role.ado_node_role.name
}


resource "aws_iam_policy" "node_policy" {
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AllowDescribeCluster",
          "Effect": "Allow",
          "Action": "eks:DescribeCluster",
          "Resource": "arn:aws:eks:eu-north-1:700935310038:cluster/k8s-main"
        }
      ]
    }

  )
}

resource "local_file" "instances_ip" {
  filename = "instances_ip"
  content  = jsonencode({
    nodes      = values(module.ec2_instance_ado_workers)[*].public_ip
  })
}