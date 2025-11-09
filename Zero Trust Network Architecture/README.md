# Zero Trust Network Architecture

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
  



