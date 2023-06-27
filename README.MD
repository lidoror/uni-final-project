# About the project
This project involves implementing a complete CI/CD process for the Telegram API service in development and production environments using Azure Devops.\
The code for the project is provided in the TelegramPy repository on the main branch.\
The project involves deploying a multi-node Kubernetes cluster using EKS .\
In this project I used azure devops to automate the life cycle of the application from the push to the deployment.\
I used self-hosted agent and in order to create them asap I used terraform to provision the servers and ansible to add the server as self-hosted node.\
The whole project run on eks and the connection from azure devops to EKS is made with Service account i created to give azure devops permissions to deploy application on two different namespaces prod and dev.




### Technologies Used
- Python
- AWS Cloud
- Docker
- K8s
- Helm
- Terraform
- Ansible

### AWS Resources
- EKS
- ASG
- NLB
- S3
- SQS
- EC2
- AWS Secrets
- Route 53



