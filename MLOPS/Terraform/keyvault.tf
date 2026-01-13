resource "azurerm_key_vault" "ml_secrets" {
  name                     = "kv-mlops-secrets-prod"
  location                 = azurerm_resource_group.mlops.location
  resource_group_name      = azurerm_resource_group.mlops.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  soft_delete_retention_days = 7

  # Set initial access policy (e.g., for the deployment user/pipeline)
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions    = ["Get"]
    secret_permissions = ["Get", "List", "Set", "Delete"]
  }
}