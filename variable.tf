variable "prefix" {
  type    = string
  default = "demo"
}

variable "location" {
  type    = string
  default = "eastus"
}
variable "resource_group" {
  type    = string
  default = "rg-aks-demo"
}
variable "vnet_name" {
  type    = string
  default = "vnet-aks-demo"
}
variable "subnet_name" {
  type    = string
  default = "snet-aks"
}
variable "aks_name" {
  type    = string
  default = "aks-demo-cluster"
}

# system node pool settings
variable "system_node_count" {
  type    = number
  default = 2
}
variable "system_node_size" {
  type    = string
  default = "Standard_DS2_v2"
}

# user/nodepool definitions as a map list
variable "extra_node_pools" {
  type = list(object({
    name               = string
    vm_size            = string
    node_count         = number
    min_count          = number
    max_count          = number
    enable_autoscale   = bool
    mode               = string # "User"
    os_type            = string # "Linux" or "Windows"
    node_labels        = map(string)
    node_taints        = list(string)
    availability_zones = list(number)
  }))
  default = [
    {
      name               = "npgeneral"
      vm_size            = "Standard_DS2_v2"
      node_count         = 2
      min_count          = 1
      max_count          = 3
      enable_autoscale   = true
      mode               = "User"
      os_type            = "Linux"
      node_labels        = { "workload" = "general" }
      node_taints        = []
      availability_zones = [1, 2, 3]
    },
    {
      name               = "npgpu"
      vm_size            = "Standard_NC6"
      node_count         = 0
      min_count          = 0
      max_count          = 2
      enable_autoscale   = true
      mode               = "User"
      os_type            = "Linux"
      node_labels        = { "workload" = "gpu" }
      node_taints        = ["sku=gpu:NoSchedule"]
      availability_zones = [1, 2]
    }
  ]
}
