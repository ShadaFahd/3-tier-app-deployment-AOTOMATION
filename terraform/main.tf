resource "azurerm_resource_group" "main_rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}


module "network" {
  source = "./modules/network"
  prefix = var.prefix
  location = var.location
  resource_group_name = azurerm_resource_group.main_rg.name
}

module "compute" {
  source               = "./modules/compute"
  prefix               = var.prefix
  location             = var.location
  vm_size              = var.vm_size
  frontend_subnet_id   = module.network.frontend_subnet_id
  backend_subnet_id    = module.network.backend_subnet_id
  appgateway_subnet_id = module.network.appgateway_subnet_id
  control_subnet_id    = module.network.control_subnet_id
  backend_pool_id      = module.network.backend_pool_id
  resource_group_name = azurerm_resource_group.main_rg.name
}

module "database" {
  source = "./modules/database"
  prefix = var.prefix
  location = var.location
  db_subnet_id = module.network.db_subnet_id
  resource_group_name = azurerm_resource_group.main_rg.name
}

module "bastion" {
  source              = "./modules/bastion"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.network.resource_group_name
  virtual_network_name = module.network.vnet_name
}

