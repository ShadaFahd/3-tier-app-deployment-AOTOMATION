resource "azurerm_mssql_server" "sql_server" {
  name = "${replace(lower(var.prefix), "/[^a-z0-9]/", "")}-sqlserver"
  resource_group_name = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "YourPassword123!"
}

resource "azurerm_mssql_database" "sql_db" {
  name      = "${var.prefix}-sqldb"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "S0"
}
