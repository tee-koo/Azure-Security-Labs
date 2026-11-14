# Azure Security Labs

A collection of hands-on infrastructure-as-code and cloud security labs for Microsoft Azure, built primarily with Terraform.

The projects explore practical Azure networking, identity, monitoring, and security controls. Each lab includes its own configuration and instructions.

## Labs

| Lab | Description |
|---|---|
| [Hub-and-Spoke Network](Hub-and-Spoke-Network/) | Deploys a Hub-and-Spoke network with Azure Firewall, Azure Bastion, network security groups, and private Blob Storage access. |
| [Microsoft Sentinel – Brute-Force Detection](Sentinel%20Detection%20Rule%20-%20Brute%20Force/) | Deploys a Sentinel analytics rule to detect repeated failed Microsoft Entra ID sign-ins and create an incident when the configured threshold is exceeded. |

## Technologies

- Microsoft Azure
- Terraform
- Microsoft Entra ID
- Microsoft Sentinel
- Azure networking and security services

## Purpose

These labs are intended for learning, experimentation, and demonstrating practical cloud security engineering concepts. They are not production-ready deployment blueprints. Review each lab's README for prerequisites, configuration, deployment steps, and security considerations.

## Getting started

Choose a lab from the list above and follow its README. You will generally need an Azure subscription, the Azure CLI, Terraform, and sufficient permissions to deploy the resources used by that lab.

Do not commit credentials, Terraform state files, plan files, or other secrets to the repository.
