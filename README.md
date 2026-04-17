# Doris Terraform Infrastructure

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