# Azure Hub-and-Spoke Architecture with Zero Trust (Terraform)  

[![Terraform](https://img.shields.io/badge/Terraform-Ready-blue)](https://terraform.io)
[![AZ-500](https://img.shields.io/badge/AZ--500-Ready-green)](#)
[![Hub-Spoke](https://img.shields.io/badge/Hub--Spoke-Deployed-success)](#)  

This repository implements an enterprise-grade, centralized Hub-and-Spoke network topology in Azure using Terraform, fully aligned with Zero Trust security principles.  

All traffic from workload subnets is forced through Azure Firewall, with no direct internet access. Secure remote access is provided via Azure Bastion.  

![pic1](pic1.jpg)  


