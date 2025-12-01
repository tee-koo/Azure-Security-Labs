# Microsoft Sentinel Detection Rule – Brute-Force Sign-ins

[![Terraform](https://img.shields.io/badge/Terraform-Ready-blue)](https://terraform.io)
[![AZ-500](https://img.shields.io/badge/AZ--500-Ready-green)](#)  

### This module deploys a Microsoft Sentinel analytics rule that:  

- Monitors **Azure AD Sign-in logs** for repeated failed logins (`ResultType == 50126`)  
- Triggers an **automatic Incident** in Sentinel when threshold is exceeded  

## Requirements
- Microsoft Sentinel must be enabled on the Log Analytics workspace  
- Azure AD Sign-in logs must be streaming to the workspace

## Usage  
```bash
terraform init
terraform plan -var-file="terraform.tfvars" -out deploy.plan
terraform apply deploy.plan
```

## Detection rule in Microsoft Sentinel  
![pic2](picture/pic2.jpg)  
