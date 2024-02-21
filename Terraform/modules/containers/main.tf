# get latest azure AKS latest Version
data "azurerm_kubernetes_service_versions" "versions" {
    location = var.location
    include_preview = false
}
#create acr
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resourcegroup
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}
# create AKS cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resourcegroup
  dns_prefix          = "${var.resourcegroup}-cluster"
  kubernetes_version = data.azurerm_kubernetes_service_versions.versions.latest_version
  node_resource_group = "${var.resourcegroup}-node-rg"

  default_node_pool {
    name       = "system"
    vm_size    = var.vm_sku
    zones = ["1", "2", "3"]
    node_count = var.system_node_count
    enable_auto_scaling = true
    min_count = var.min_node_count
    max_count = var.max_node_count
    temporary_name_for_rotation = "rgdevnewnode"
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    node_labels         = {
      "nodepool" = "system"
      "env"      = "demo"
    }
  }
identity {
    type = "UserAssigned"
    identity_ids = [var.managed_identity_id]  
}
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_id
  }
  tags = {
      "nodepool" = "system"
      "env"      = "demo"
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
}
 }