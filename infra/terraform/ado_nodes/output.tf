output "ec2_key_name" {
  value = data.aws_key_pair.servers_key.key_name
}

output "ec2_key_id" {
  value = data.aws_key_pair.servers_key.id
}

output "k0s_workers_public_ips" {
  value = values(module.ec2_instance_ado_workers)[*].public_ip
}