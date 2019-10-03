resource "azurerm_resource_group" "test1" {
  name     = "tarraform-resouces-abhishek"
  location = "${var.location}"
}

resource "azurerm_app_service_plan" "test1" {
  name                = "example-appserviceplan"
  location            = "${azurerm_resource_group.test1.location}"
  resource_group_name = "tarraform-resouces-abhishek"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "test1" {
  name                = "tarraform-resouces-abhi"
  location            = "${azurerm_resource_group.test1.location}"
  resource_group_name = "tarraform-resouces-abhishek"
  app_service_plan_id = "${azurerm_app_service_plan.test1.id}"

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=tcp:${azurerm_sql_server.test1.fully_qualified_domain_name} Database=${azurerm_sql_database.test1.name};User ID=${azurerm_sql_server.test1.administrator_login};Password=${azurerm_sql_server.test1.administrator_login_password};Trusted_Connection=False;Encrypt=True;"
  }
}

resource "azurerm_sql_server" "test" {
  name                         = "terraform-sqlserver"
  resource_group_name          = "tarraform-resouces-abhishek"
  location                     = "${azurerm_resource_group.test1.location}"
  version                      = "12.0"
  administrator_login          = "houssem"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "test1" {
  name                = "terraform-sqldatabase"
  resource_group_name = "tarraform-resouces-abhishek"
  location            = "${azurerm_resource_group.test1.location}"
  server_name         = "${azurerm_sql_server.test1.name}"

  tags = {
    environment = "production"
  }
}
