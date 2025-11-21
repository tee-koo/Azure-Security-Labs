# Azure Hub-and-Spoke Architecture with Zero Trust (Terraform)  

[![Terraform](https://img.shields.io/badge/Terraform-Ready-blue)](https://terraform.io)
[![AZ-500](https://img.shields.io/badge/AZ--500-Ready-green)](#)
[![Hub-Spoke](https://img.shields.io/badge/Hub--Spoke-Deployed-success)](#)  

This repository implements an enterprise-grade, centralized Hub-and-Spoke network topology in Azure (Sweden Central) using Terraform, fully aligned with Zero Trust security principles.  

All traffic from workload subnets is forced through Azure Firewall, with no direct internet access. Secure remote access is provided via Azure Bastion, and all resources are tagged for governance and lifecycle management.  

graph TD
    subgraph Internet
        World[Internet / Public Web]
    end

    subgraph Azure_Sweden_Central [Azure Region: Sweden Central]
        
        subgraph Hub_VNet [Hub VNet]
            style Hub_VNet fill:#e6f2ff,stroke:#0066cc,stroke-width:2px
            FW[Azure Firewall]
            Bastion[Azure Bastion]
        end

        subgraph Spoke_VNet [Spoke VNet]
            style Spoke_VNet fill:#f9f9f9,stroke:#666,stroke-dasharray: 5 5
            
            subgraph App_Subnet [App Subnet]
                VM_App[App VM]
            end
            
            subgraph DB_Subnet [DB Subnet]
                VM_DB[Database]
            end
        end
    end

    %% Liikennevirrat
    VM_App -- "UDR: 0.0.0.0/0" --> FW
    VM_DB -- "UDR: 0.0.0.0/0" --> FW
    FW -- "Allowed Traffic Only" --> World
    
    %% Peering
    Hub_VNet <--> |VNet Peering| Spoke_VNet

    %% Bastion yhteys
    Bastion -.-> |SSH/RDP| VM_App
    
    classDef resource fill:#fff,stroke:#333,stroke-width:1px;
    class FW,Bastion,VM_App,VM_DB resource;




