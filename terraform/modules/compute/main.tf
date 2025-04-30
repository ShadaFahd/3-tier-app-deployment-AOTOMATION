resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "${var.prefix}-appgw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = "${var.prefix}-appgw"
  location            = var.location
  resource_group_name = var.resource_group_name


  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.appgateway_subnet_id
  }

  frontend_port {
    name = "frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_public_ip.id
  }

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 3000
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 10
  }
}

resource "azurerm_network_security_group" "frontend_nsg" {
  name                = "${var.prefix}-frontend-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "backend_nsg" {
  name                = "${var.prefix}-backend-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-App-Traffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SonarQube"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "frontend_nsg_assoc" {
  count                    = 2
  network_interface_id     = azurerm_network_interface.frontend_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}

resource "azurerm_network_interface_security_group_association" "backend_nsg_assoc" {
  count                    = 2
  network_interface_id     = azurerm_network_interface.backend_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}

resource "azurerm_network_interface" "frontend_nic" {
  count               = 2
  name                = "${var.prefix}-frontend-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "frontend-ip-config"
    subnet_id                     = var.frontend_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "frontend_vm" {
  count               = 2
  name                = "${var.prefix}-frontend-vm-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = "azureuser"
  admin_password      = "DevPassword123!"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.frontend_nic[count.index].id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_network_interface" "backend_nic" {
  count               = 2
  name                = "${var.prefix}-backend-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "backend-ip-config"
    subnet_id                     = var.backend_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "backend_vm" {
  count               = 2
  name                = "${var.prefix}-backend-vm-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = "azureuser"
  admin_password      = "DevPassword123!"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.backend_nic[count.index].id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_lb_association" {
  count                     = 2
  network_interface_id      = azurerm_network_interface.backend_nic[count.index].id
  ip_configuration_name     = "backend-ip-config"
  backend_address_pool_id = var.backend_pool_id
}

resource "azurerm_network_security_group" "control_nsg" {
  name                = "${var.prefix}-control-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface" "control_nic" {
  name                = "${var.prefix}-control-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "control-ip-config"
    subnet_id                     = var.control_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_network_interface_security_group_association" "control_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.control_nic.id
  network_security_group_id = azurerm_network_security_group.control_nsg.id
}


resource "azurerm_linux_virtual_machine" "control_vm" {
  name                = "${var.prefix}-control-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = "azureuser"
  admin_password      = "DevPassword123!"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.control_nic.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

