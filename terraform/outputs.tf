output "frontend_vm_ips" {
  value = module.compute.frontend_vm_ips
}

output "backend_vm_ips" {
  value = module.compute.backend_vm_ips
}

output "application_gateway_public_ip" {
  value = module.compute.appgw_public_ip
}

output "sql_server_name" {
  value = module.database.sql_server_name
}

output "resource_group_name" {
  value = azurerm_resource_group.main_rg.name
}
