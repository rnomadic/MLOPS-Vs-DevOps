# Prerequisite: Storage Account
resource "azurerm_storage_account" "ml_storage" {
  name                     = "mlopssastore" # Globally unique
  location                 = azurerm_resource_group.mlops.location
  resource_group_name      = azurerm_resource_group.mlops.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# The core ML Workspace resource
resource "azurerm_machine_learning_workspace" "ml_workspace" {
  name                    = "mlw-production-001"
  location                = azurerm_resource_group.mlops.location
  resource_group_name     = azurerm_resource_group.mlops.name
  
  # CRITICAL DEPENDENCIES - ML Workspace must be linked to these
  application_insights_id = azurerm_application_insights.ml_app_insights.id
  key_vault_id            = azurerm_key_vault.ml_secrets.id
  storage_account_id      = azurerm_storage_account.ml_storage.id
  
  # Managed Identity is standard for secure workspaces
  identity {
    type = "SystemAssigned"
  }
}

# Attach the AKS cluster as a compute target for the ML Workspace
resource "azurerm_machine_learning_compute_cluster" "aks_target" {
  name                    = "aks-inference-cluster"
  location                = azurerm_resource_group.mlops.location
  resource_group_name     = azurerm_resource_group.mlops.name
  machine_learning_workspace_id = azurerm_machine_learning_workspace.ml_workspace.id
  
  # Reference the already-created AKS cluster
  cluster_resource_id     = azurerm_kubernetes_cluster.ml_aks.id
  cluster_purpose         = "AmlCompute"
}