# Create additional node pools using azurerm_kubernetes_cluster_node_pool
resource "azurerm_kubernetes_cluster_node_pool" "extra" {
  for_each = { for np in var.extra_node_pools : np.name => np }

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  auto_scaling_enabled  = each.value.enable_autoscale
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  mode                  = each.value.mode
  os_type               = each.value.os_type
  max_pods              = 110

  # availability zones expects strings "1","2"...
  zones = each.value.availability_zones

  node_labels = each.value.node_labels
  node_taints = each.value.node_taints # e.g. ["workload=jobs:NoSchedule"]

  tags = {
    created_by = "terraform"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}
