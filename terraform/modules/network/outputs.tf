output "frontend_subnet_id" {
  value = azurerm_subnet.frontend_subnet.id
}

output "backend_subnet_id" {
  value = azurerm_subnet.backend_subnet.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.backend_pool.id
}

output "appgateway_subnet_id" {
  value = azurerm_subnet.appgateway_subnet.id
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}


output "control_subnet_id" {
  value = azurerm_subnet.control_subnet.id
}
