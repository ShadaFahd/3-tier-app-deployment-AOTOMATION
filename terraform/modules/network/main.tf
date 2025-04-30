resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "frontend_subnet" {
  name                 = "${var.prefix}-frontend-subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "backend_subnet" {
  name                 = "${var.prefix}-backend-subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "${var.prefix}-db-subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "appgateway_subnet" {
  name                 = "${var.prefix}-appgw-subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_subnet" "control_subnet" {
  name                 = "${var.prefix}-control-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.6.0/24"]
}


# Internal Load Balancer للـ Backend
resource "azurerm_lb" "backend_internal_lb" {
  name                = "${var.prefix}-backend-ilb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "internal-frontend"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.backend_internal_lb.id
}

# Health Probe
resource "azurerm_lb_probe" "backend_probe" {
  name                = "backend-health-probe"
  loadbalancer_id     = azurerm_lb.backend_internal_lb.id
  protocol            = "Tcp"
  port                = 3000
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load Balancing Rule
resource "azurerm_lb_rule" "backend_lb_rule" {
  name                           = "backend-lb-rule"
  loadbalancer_id                = azurerm_lb.backend_internal_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 3000
  backend_port                   = 3000
  frontend_ip_configuration_name = "internal-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.backend_probe.id
}
