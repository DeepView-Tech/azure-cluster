locals {
  kube_version = null
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-aks"

  default_node_pool {
    name                = "system" # system node pool (required)
    node_count          = var.system_node_count
    vm_size             = var.system_node_size
    os_type             = "Linux"
    mode                = "System"
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    max_pods            = 110
    enable_auto_scaling = false
    # availability_zones = ["1","2","3"] # optional
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet" # or "azure" for Azure CNI
    load_balancer_sku = "standard"
  }

  addon_profile {
    oms_agent {
      enabled = false
    }
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "demo"
  }

  # Optional Kubernetes version pin
  # kubernetes_version = local.kube_version
}
