# get latest azure AKS latest Version
data "azurerm_kubernetes_service_versions" "versions" {
    location = var.location
    include_preview = false
}
#create role assignment for acr pull with aks
resource "azurerm_role_assignment" "aks_mi_role_acrpull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}
#create role assignment for acr pull with managed identity
resource "azurerm_role_assignment" "mi_role_acrpull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.managed_identity_principal_id
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
  role_based_access_control_enabled = false  # allows Entra ID identities to be used inside k8s
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
  # # allows Entra ID groups to be cluster administrators
  # azure_active_directory_role_based_access_control {
  #   managed                = true
  #   admin_group_object_ids = var.admin_groups
  #   azure_rbac_enabled     = true
  # }
 # observability
  microsoft_defender {
    log_analytics_workspace_id = var.log_analytics_id
  }
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_id
  }
  tags = {
      "nodepool" = "system"
      "env"      = "demo"
  }
  # adds KeyVault Secrets Provider
  # key_vault_secrets_provider {
  #   secret_rotation_enabled  = false
  #   secret_rotation_interval = "2m"
  # }
  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = tls_private_key.ssh_key.public_key_openssh
      #key_data = file(var.ssh_public_key)
      #key_data = data.tls_public_key.ssh_public_key.public_key_openssh
      # key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
}
 }
# # Generate SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
# rsa_bits  = 2048
 }
# # Extract public key from the generated private key
# data "tls_public_key" "ssh_public_key" {
#   private_key_pem = tls_private_key.ssh_key.private_key_pem
# }
resource "local_file" "private_key" {
  content  = trimspace(tls_private_key.ssh_key.private_key_pem)
  filename = "${path.module}/id_rsa"
}
resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/id_rsa.pub"
}