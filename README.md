# Doris Terraform Infrastructure

This Terraform project automates the deployment of a multi-tier application infrastructure on AWS, consisting of frontend and backend EC2 instances with proper security group configurations.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Configuration](#configuration)
- [Variables](#variables)
- [Outputs](#outputs)
- [Security](#security)
- [Troubleshooting](#troubleshooting)

---

## Project Overview

This Terraform configuration deploys a production-ready Doris application infrastructure in AWS with the following components:

- **3 Frontend Instances** (t3.large) - Web tier running in private subnets
- **1 Backend Instance** (t3.xlarge) - Application tier running in private subnet
- **Security Groups** - Separate security groups for frontend and backend with defined ingress/egress rules
- **Encrypted EBS Volumes** - Storage for instances with encryption enabled
- **SSH Access** - Key pair-based authentication for secure access

### Environment: Development (dev)
- **Region**: ap-south-1 (Asia Pacific - Mumbai)
- **Deployment Strategy**: Infrastructure as Code using Terraform

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        VPC                                  │
│                   (vpc-0d15d65b05ac9ace0)                   │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │        Frontend Private Subnet                        │  │
│  │   (subnet-088148e90fe17306a)                          │  │
│  │                                                       │  │
│  │  ┌─────────────────┐  ┌─────────────────┐           │  │
│  │  │   frontend-1    │  │   frontend-2    │           │  │
│  │  │   t3.large      │  │   t3.large      │           │  │
│  │  │   (FE-SG)       │  │   (FE-SG)       │           │  │
│  │  └─────────────────┘  └─────────────────┘           │  │
│  │                                                       │  │
│  │  ┌─────────────────┐                                 │  │
│  │  │   frontend-3    │                                 │  │
│  │  │   t3.large      │                                 │  │
│  │  │   (FE-SG)       │                                 │  │
│  │  └─────────────────┘                                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Backend Private Subnet                        │  │
│  │   (subnet-0c16a05cb6e94254b)                          │  │
│  │                                                       │  │
│  │  ┌─────────────────┐                                 │  │
│  │  │    backend-1    │                                 │  │
│  │  │   t3.xlarge     │                                 │  │
│  │  │   (be-sg)       │                                 │  │
│  │  └─────────────────┘                                 │  │
│  │                                                       │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

Before deploying this infrastructure, ensure you have:

1. **AWS Account** - An active AWS account with appropriate permissions
2. **Terraform** - Version 1.0 or higher installed locally
3. **AWS CLI** - Configured with appropriate credentials
4. **SSH Key Pair** - Created in AWS (name: `doris`)
   - Used for accessing EC2 instances via SSH
5. **VPC & Subnets** - Pre-created in your AWS account:
   - VPC ID: `vpc-0d15d65b05ac9ace0`
   - Frontend Subnet: `subnet-088148e90fe17306a`
   - Backend Subnet: `subnet-0c16a05cb6e94254b`
6. **Security Groups** - Pre-created:
   - `FE-SG` - Frontend security group
   - `be-sg` - Backend security group
7. **AMI** - Ubuntu 22.04 AMI available in your region
   - Current AMI ID: `ami-0a1b0c508e1fa9fce` (ap-south-1)

---

## Project Structure

```
doris/
├── README.md                          # This file
├── modules/
│   └── ec2/
│       ├── main.tf                    # EC2 module implementation
│       ├── variables.tf               # Input variables for EC2 module
│       └── outputs.tf                 # Output values from EC2 module
│
└── wrapper/
    └── env/
        └── dev/
            └── application/
                └── doris/
                    ├── main.tf        # Main configuration (module call)
                    ├── variables.tf   # Input variables for dev environment
                    ├── locals.tf      # Local values (instance configs, tags)
                    ├── outputs.tf     # Output values
                    ├── backend.tf     # Terraform backend configuration
                    └── terraform.tfvars # Variable values (dev environment)
```

### File Descriptions

#### **modules/ec2/**
This module is reusable and responsible for:
- Creating EC2 instances from a provided configuration map
- Attaching security groups to instances
- Configuring root block devices with encryption
- Managing additional EBS volumes
- Assigning public/private IPs
- Setting termination protection

#### **wrapper/env/dev/application/doris/**
The wrapper configuration that:
- Calls the EC2 module with dev-specific settings
- Defines 3 frontend and 1 backend instance
- Sets common tags for environment and project
- Manages security group associations
- Provides input variables for the deployment

---

## Usage

### 1. **Initialize Terraform**

Navigate to the deployment directory and initialize:

```bash
cd wrapper/env/dev/application/doris/
terraform init
```

This command:
- Downloads the required providers (AWS)
- Initializes the backend (if configured)
- Prepares the working directory

### 2. **Plan the Deployment**

Preview the infrastructure changes before applying:

```bash
terraform plan -out=tfplan
```

This will show:
- Resources to be created
- Variable values being used
- Security group configurations
- Instance specifications

### 3. **Apply the Configuration**

Deploy the infrastructure:

```bash
terraform apply tfplan
```

or directly:

```bash
terraform apply
```

Terraform will:
- Create 4 EC2 instances (3 frontend + 1 backend)
- Configure security groups
- Set up EBS volumes with encryption
- Tag resources appropriately

### 4. **Verify Deployment**

After successful deployment:

```bash
terraform output
```

This displays the private IPs of all deployed instances.

### 5. **Access Instances**

Once instances are running, access them via SSH:

```bash
# Frontend instances
ssh -i doris.pem ec2-user@<frontend-private-ip>

# Backend instance
ssh -i doris.pem ec2-user@<backend-private-ip>
```

Note: Use an SSH bastion/jump host since instances are in private subnets.

---

## Configuration

### Instance Types

| Instance | Type | vCPU | Memory | Purpose |
|----------|------|------|--------|---------|
| frontend-1, 2, 3 | t3.large | 2 | 8 GB | Web tier / Load distribution |
| backend-1 | t3.xlarge | 4 | 16 GB | Application logic |

### Storage Configuration

| Instance Type | Root Volume Size | Volume Type | Throughput | Encryption |
|---------------|------------------|-------------|------------|------------|
| Frontend | 50 GB | gp3 | 125 MB/s | Yes (AES-256) |
| Backend | 100 GB | gp3 | 125 MB/s | Yes (AES-256) |

### Networking

- **Instances**: Deployed in private subnets (no direct internet access)
- **Public IP**: Not assigned (backend connectivity via private IPs)
- **SSH Access**: Only via security group rules and bastion host
- **Security Groups**:
  - **FE-SG** (Frontend): Port 9030 TCP inbound from backend
  - **be-sg** (Backend): Port 9050 TCP inbound from frontend

---

## Variables

### Required Variables

#### `ami_id`
- **Type**: `string`
- **Description**: AMI ID for EC2 instances
- **Current Value**: `ami-0a1b0c508e1fa9fce` (Ubuntu 22.04 in ap-south-1)
- **Note**: Change if deploying to a different region

#### `ssh_key_name`
- **Type**: `string`
- **Description**: SSH key pair name for EC2 instances
- **Current Value**: `doris`
- **Note**: Key pair must exist in your AWS account

#### `frontend_private_subnet_id`
- **Type**: `string`
- **Description**: Private subnet ID for frontend instances
- **Current Value**: `subnet-088148e90fe17306a`

#### `backend_private_subnet_id`
- **Type**: `string`
- **Description**: Private subnet ID for backend instances
- **Current Value**: `subnet-0c16a05cb6e94254b`

#### `vpc_id`
- **Type**: `string`
- **Description**: VPC ID where resources are deployed
- **Current Value**: `vpc-0d15d65b05ac9ace0`

### Optional Variables

#### `ec2_enabled`
- **Type**: `bool`
- **Default**: `true`
- **Description**: Enable or disable the entire EC2 deployment
- **Use Case**: Quick disable of all instances without destroying

#### `security_group_names`
- **Type**: `list(string)`
- **Default**: `["FE-SG", "be-sg"]`
- **Description**: Existing security group names for instances

#### `security_group_ingress_rules`
- **Type**: `map(object({...}))`
- **Default**: Includes rules for ports 9030 (FE) and 9050 (BE)
- **Description**: Custom ingress rules for security groups

#### `security_group_egress_rules`
- **Type**: `map(object({...}))`
- **Default**: Allow all outbound traffic on backend
- **Description**: Custom egress rules for security groups

### Modifying Variables

To change variables, update [terraform.tfvars](wrapper/env/dev/application/doris/terraform.tfvars):

```hcl
# Example: Change instance type
ec2_enabled = true
ami_id      = "ami-0a1b0c508e1fa9fce"
ssh_key_name = "your-key-name"
```

Or pass via CLI:

```bash
terraform apply -var="ssh_key_name=my-key" -var="ec2_enabled=false"
```

---

## Outputs

### `private_ips`

Returns a map of instance names to their private IP addresses:

```
private_ips = {
  "backend-1"   = "10.0.2.50"
  "frontend-1"  = "10.0.1.10"
  "frontend-2"  = "10.0.1.20"
  "frontend-3"  = "10.0.1.30"
}
```

**Usage**: Reference these IPs for:
- Configuring load balancers
- Setting up DNS records
- Application connectivity
- Monitoring and logging

To retrieve outputs after deployment:

```bash
terraform output
terraform output -json  # JSON format
terraform output private_ips  # Specific output
```

---

## Security

### Best Practices Implemented

1. **Encrypted Volumes**
   - All root volumes are encrypted with AES-256
   - EBS encryption enabled at rest

2. **Network Isolation**
   - Instances in private subnets (no internet exposure)
   - Security groups with minimal required ports
   - Separate security groups for frontend and backend

3. **SSH Access**
   - Key pair authentication (no password)
   - Secure key file required (`doris.pem`)
   - Requires bastion/jump host for private subnet access

4. **Termination Protection**
   - Currently disabled (set `termination_protection = false`)
   - Enable if preventing accidental deletion is required

### Security Considerations

- **Security Group Rules**: Currently allow traffic between FE-SG and be-sg on ports 9030/9050
  - Review these ports based on your application needs
  - Consider restricting to specific IPs rather than security groups

- **SSH Key Management**
  - Keep `doris.pem` secure and never commit to version control
  - Rotate keys periodically
  - Use separate keys per environment

- **IAM Instance Profile**
  - Currently optional; add if EC2 instances need AWS service access
  - Define minimal required permissions

- **VPC Flow Logs**
  - Consider enabling for traffic monitoring

---

## Troubleshooting

### Issue: Authentication Failed
**Error**: `Error: error retrieving EC2 Instances: AuthFailure.Unauthorized Operation`

**Solution**:
1. Verify AWS credentials are configured: `aws sts get-caller-identity`
2. Ensure IAM user has EC2 permissions
3. Check if credentials are expired

### Issue: Security Group Not Found
**Error**: `Error: security group not found`

**Solution**:
1. Verify security groups exist in the specified VPC
2. Check security group names match exactly (case-sensitive)
3. Confirm VPC ID is correct

### Issue: Subnet Not Found
**Error**: `Error: subnet not found`

**Solution**:
1. Verify subnet IDs exist in the same VPC
2. Confirm subnets are in the correct region
3. Check subnet availability

### Issue: AMI Not Found
**Error**: `Error: AMI not found`

**Solution**:
1. Verify AMI ID exists in your region
2. Ubuntu 22.04 AMI may differ by region; check AWS Console
3. Ensure you have access to the AMI (not deprecated)

### Issue: SSH Key Not Found
**Error**: `Error: key pair not found`

**Solution**:
1. Create the SSH key pair in AWS: `aws ec2 create-key-pair --key-name doris --region ap-south-1`
2. Save the private key securely
3. Set correct permissions: `chmod 600 doris.pem`

### Issue: Insufficient Capacity
**Error**: `InsufficientInstanceCapacity`

**Solution**:
1. Try a different availability zone
2. Change instance type to a smaller size temporarily
3. Wait and retry later

### Issue: Terraform State Lock
**Error**: `Error acquiring the lock`

**Solution**:
1. Check if another Terraform operation is running
2. Force unlock if stuck: `terraform force-unlock <LOCK_ID>`
3. Verify backend configuration

---

## Terraform Commands Reference

| Command | Purpose |
|---------|---------|
| `terraform init` | Initialize working directory |
| `terraform plan` | Preview changes |
| `terraform apply` | Deploy infrastructure |
| `terraform destroy` | Destroy all resources |
| `terraform output` | View output values |
| `terraform state list` | List all resources in state |
| `terraform state show <resource>` | Show specific resource details |
| `terraform refresh` | Sync local state with AWS |
| `terraform validate` | Validate configuration syntax |
| `terraform fmt` | Format Terraform files |

---

## Cost Estimation

### Approximate Monthly Costs (ap-south-1)

| Resource | Count | Type | Est. Cost/Month |
|----------|-------|------|-----------------|
| EC2 - t3.large | 3 | On-Demand | ~$40 |
| EC2 - t3.xlarge | 1 | On-Demand | ~$35 |
| EBS - GP3 (50 GB × 3) | 150 GB | Storage | ~$15 |
| EBS - GP3 (100 GB × 1) | 100 GB | Storage | ~$5 |
| EBS Throughput | 500 MB/s | Throughput | ~$20 |
| **Total Estimated** | - | - | **~$115/month** |

*Note: Prices are approximate and may vary. Use AWS Cost Calculator for accurate estimates.*

---

## Maintenance & Updates

### Regular Maintenance Tasks

1. **Patch Management**
   - Update AMI ID when new versions are available
   - Apply OS patches monthly

2. **Backup**
   - Consider AWS Backup for automated snapshots
   - Test recovery procedures

3. **Monitoring**
   - Enable CloudWatch monitoring
   - Set up alerts for CPU, memory, disk usage

4. **Scaling**
   - Monitor frontend instance capacity
   - Consider Auto Scaling Groups for dynamic scaling

---

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices)
- [AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)

---

## Support & Contributions

For issues, improvements, or contributions:
1. Review this documentation thoroughly
2. Check AWS and Terraform documentation
3. Verify all prerequisites are met
4. Consult team members for environment-specific issues

---

**Last Updated**: 2026-04-17  
**Project**: Doris Infrastructure  
**Environment**: Development  
**Region**: ap-south-1 (Asia Pacific - Mumbai)
