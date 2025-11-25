# Project Overview – Azure Sentinel SIEM with Terraform & KQL  

[![Terraform](https://img.shields.io/badge/Terraform-Ready-blue)](https://terraform.io)
[![AZ-500](https://img.shields.io/badge/AZ--500-Ready-green)](#)  

This project demonstrates how to detect brute-force login attempts in Azure Active Directory using Microsoft Sentinel.  
The alert rule is provisioned via Terraform and custom KQL query that analyzes failed sign-in events.  

```bash
terraform init
terraform plan -var-file="terraform.tfvars" -out deploy.plan
terraform apply deploy.plan
```  
![pic2](pic2.jpg)  
