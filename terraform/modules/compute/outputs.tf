output "frontend_vm_ips" {
  value = [for nic in azurerm_network_interface.frontend_nic : nic.private_ip_address]
}

output "backend_vm_ips" {
  value = [for nic in azurerm_network_interface.backend_nic : nic.private_ip_address]
}

output "appgw_public_ip" {
  value = azurerm_public_ip.appgw_public_ip.ip_address
}
