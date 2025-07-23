# 🚀 8Byte Terraform Infrastructure Deployment

This project provisions a secure, highly available AWS infrastructure using **Terraform**, with centralized secrets management via **HashiCorp Vault** and **AWS Secrets Manager**. It also ensures best practices for **cost optimization**, **disaster recovery planning**, and **multi-AZ deployments**.

---

## 📁 Project Structure

```plaintext
8Byte_Assignment/
├── backend.tf           # Remote state storage configuration (S3 + DynamoDB)
├── main.tf              # Core infrastructure setup using terraform-aws-modules
├── variables.tf         # Input variable declarations
├── terraform.tfvars     # Actual variable values
├── outputs.tf           # Output resources like instance IDs, VPC IDs, etc.

---

## 🔧 Setup Instructions

### 1. Install Terraform and Vault

- **Terraform Installation:**  
  [How to Install Terraform on Ubuntu](https://computingforgeeks.com/how-to-install-terraform-on-ubuntu/)

- **Vault Installation:**  
  [How to Install HashiCorp Vault](https://developer.hashicorp.com/vault/install)

---

### 2. Vault Setup & Secret Injection

```bash
# Start Vault Server
nohup vault server -config=/etc/vault.d/vault.hcl > vault.log 2>&1 &

# Initialize Vault (store generated keys safely)
vault operator init

# Unseal Vault (run 3 times with 3 different keys)
vault operator unseal <Unseal_Key_1>
vault operator unseal <Unseal_Key_2>
vault operator unseal <Unseal_Key_3>

# Login with root token
vault login <Vault_Root_Token>

# Inject AWS secrets into Vault
vault kv put my-secrets/aws \
  aws_access_key_id=<YOUR_ACCESS_KEY_ID> \
  aws_secret_access_key=<YOUR_SECRET_ACCESS_KEY>


3. Create and Switch Terraform Workspace
terraform workspace new staging
terraform workspace select staging

🏗️ Infrastructure Details
Uses official terraform-aws-modules (e.g., EC2, VPC, RDS, ALB).

Secure remote state management with S3 and DynamoDB locking.

Supports high availability with multi-AZ deployments.

Scalable and modular for staging and production environments.

🔐 Security Considerations
AWS credentials securely managed in HashiCorp Vault.

AWS Secrets Manager stores sensitive DB credentials.

RDS is deployed in private subnets with no public access.

Security groups restricted to allow access only from trusted IP ranges (VPNs).

Terraform state bucket access is tightly controlled using IAM.


💰 Cost Optimization
Resource provisioning based on actual application requirements.

Spot instances can be optionally configured.

Read replicas and auto-scaling help balance cost vs. performance.

Automated RDS snapshots and lifecycle policies.


📈 High Availability & DR Planning
Multi-AZ architecture for EC2 and RDS.

Read replicas configured for RDS.

Automated and cross-region backups enabled.

Disaster Recovery (DR) strategy in place for critical workloads.


▶️ Running Terraform

# Switch to root
sudo su - root

# Start Vault and unseal
nohup vault server -config=/etc/vault.d/vault.hcl > vault.log 2>&1 &
vault operator unseal <Unseal_Key_1>
vault operator unseal <Unseal_Key_2>
vault operator unseal <Unseal_Key_3>

# Enter the Terraform directory
cd 8Byte_Assignment

# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply infrastructure changes
terraform apply

# To destroy all resources
terraform destroy



📚 How Terraform Files Were Written
Started by exploring the AWS Console UI and mapping relevant options to Terraform equivalents.

Matched UI keywords (e.g., Image ID) with Terraform module input variables (e.g., ami).

Used terraform-aws-modules from the Terraform Registry to build faster and with best practices.



✅ Best Practices Followed
Remote state with locking (S3 + DynamoDB).

Secrets stored securely (Vault + Secrets Manager).

High availability and DR-ready infra.

Access control and subnet-level isolation.

Clean and modular Terraform structure.

