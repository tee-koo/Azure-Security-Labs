locals {
  rg_name  = "rg-hub-spoke-network"
  location = var.location
}

module "hub" {
  source              = "./modules/hub"
  resource_group_name = local.rg_name
  location            = local.location
}

module "spoke_dev" {
  source              = "./modules/spoke"
  resource_group_name = local.rg_name
  location            = local.location
  hub_vnet_id         = module.hub.vnet_id
  firewall_private_ip = module.hub.firewall_private_ip
  spoke_name          = "dev"
  spoke_cidr          = "10.100.10.0/16"
  depends_on          = [module.hub]
}

module "spoke_prod" {
  source              = "./modules/spoke"
  resource_group_name = local.rg_name
  location            = local.location
  hub_vnet_id         = module.hub.vnet_id
  firewall_private_ip = module.hub.firewall_private_ip
  spoke_name          = "prod"
  spoke_cidr          = "10.100.20.0/16"
  depends_on          = [module.hub]
}
