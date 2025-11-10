# Zero Trust Network Architecture

[![Terraform](https://img.shields.io/badge/Terraform-Ready-blue)](https://terraform.io)
[![AZ-500](https://img.shields.io/badge/AZ--500-Ready-green)](#)
[![Hub-Spoke](https://img.shields.io/badge/Hub--Spoke-Deployed-success)](#)

### This repository outlines the implementation of an enterprise-grade, centralized network topology in Azure, often referred to as the Hub-and-Spoke model. This architecture is the foundation for secure cloud adoption and directly implements Zero Trust principles.  

| Feature | Why It Matters |
|-------|----------------|
| **Forced Routing (UDR)** | Proves traffic cannot bypass firewall — enterprise security standard |
| **Private Link** | Eliminates public endpoints for PaaS — compliance & defense-in-depth |
| **Modular Terraform** | Clean, reusable, production-ready IaC |  

## Tech Stack

- **Terraform** (modular, reusable)
- **Azure Firewall**, **Bastion**, **VNet Peering**
- **UDR**, **Private Endpoints**
  



