resource "azurerm_kubernetes_cluster" "ml_aks" {
  name                = "aks-ml-production"
  location            = azurerm_resource_group.mlops.location
  resource_group_name = azurerm_resource_group.mlops.name
  dns_prefix          = "mlops-prod-k8s"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
  
  # ... other critical configurations like RBAC, networking, integration with Key Vault CSI Driver (post-provisioning)
}