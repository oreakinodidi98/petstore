locals {
  tags = {
    environment = "dev"
    owner       = "Ore"
    description = "Pet project"
  }
}
resource "azurerm_resource_group" "resourcegroup" {
  name     = var.resourcegroup
  location = var.location
  tags     = local.tags
}
# call the managed identity module
module "managed_identity" {
  source           = "./modules/identity"
  location         = var.location
  naming_prefix    = var.naming_prefix
  resourcegroup    = var.resourcegroup
  resourcegroup_id = azurerm_resource_group.resourcegroup.id
  acr_id           = module.containers.acr_id
  key_vault_id     = module.keyvault.key_vault_id
  depends_on       = [azurerm_resource_group.resourcegroup]
}
# call the containers module
module "containers" {
  source                        = "./modules/containers"
  location                      = var.location
  resourcegroup                 = var.resourcegroup
  aks_cluster_name              = var.aks_cluster_name
  acr_name                      = var.acr_name
  system_node_count             = var.system_node_count
  log_analytics_id              = module.monitoring.azurerm_log_analytics_workspace_id
  vm_sku                        = var.vm_sku
  resourcegroup_id              = azurerm_resource_group.resourcegroup.id
  min_node_count                = var.min_node_count
  max_node_count                = var.max_node_count
  managed_identity_name         = module.managed_identity.managed_identity_name
  managed_identity_id           = module.managed_identity.managed_identity_id
  managed_identity_principal_id = module.managed_identity.managed_identity_principal_id
  depends_on                    = [azurerm_resource_group.resourcegroup]
}
# call the logs module
module "monitoring" {
  source                      = "./modules/logs"
  env_name                    = var.env_name
  location                    = var.location
  naming_prefix               = var.naming_prefix
  appsvcid                    = module.appservice.prod_app_svc_id
  resourcegroup               = var.resourcegroup
  log_analytics_workspace_sku = var.log_analytics_workspace_sku
  depends_on                  = [azurerm_resource_group.resourcegroup]
}
# call the appservice module
module "appservice" {
  source                     = "./modules/appservice"
  location                   = var.location
  resourcegroup              = var.resourcegroup
  naming_prefix              = var.naming_prefix
  tags                       = local.tags
  instrumentation_key        = module.monitoring.instrumentation_key
  managed_identity_id        = module.managed_identity.managed_identity_id
  managed_identity_client_id = module.managed_identity.managed_identity_client_id
  acr_name                   = var.acr_name
  registry_password          = module.containers.registry_password
  depends_on                 = [azurerm_resource_group.resourcegroup]
}
# call the keyvault module
module "keyvault" {
  source                          = "./modules/keyvault"
  location                        = var.location
  resourcegroup                   = var.resourcegroup
  naming_prefix                   = var.naming_prefix
  managed_identity_principal_id   = module.managed_identity.managed_identity_principal_id
  sku_name                        = var.sku_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  depends_on                      = [azurerm_resource_group.resourcegroup]
}
# # Key Vault Secrets - ACR username & password
module "kv_secret_docker_password" {
  source = "./modules/keyvaultsecret"

  name         = "acr-docker-password"
  value        = module.containers.registry_password
  key_vault_id = module.keyvault.key_vault_id

  depends_on = [module.keyvault.azurerm_key_vault_access_policy]
}

module "kv_secret_docker_username" {
  source = "./modules/keyvaultsecret"

  name         = "acr-docker-username"
  value        = module.containers.registry_username
  key_vault_id = module.keyvault.key_vault_id

  depends_on = [module.keyvault.azurerm_key_vault_access_policy]
}
