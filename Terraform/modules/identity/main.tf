data "azurerm_subscription" "current" {}
data "azuread_client_config" "current" {}
data "azurerm_client_config" "current" {}

#create managed identity
resource "azurerm_user_assigned_identity" "app_assigned" {
  name                = "petstore_MI"
  location            = var.location
  resource_group_name = var.resourcegroup
}
#create role assighnment at RG scope with managed identity
resource "azurerm_role_assignment" "role_rg" {
  scope                = var.resourcegroup_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
}
# create contributor role assignment at subscription scope with managed identity
resource "azurerm_role_assignment" "contributor_role_assignment" {
  scope                = var.resourcegroup_id
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
  role_definition_name = "Contributor"
}
# resource "azurerm_role_assignment" "aks_role_assighment" {
#   scope                = var.aks_id
#   role_definition_name = "Azure Kubernetes Service Cluster User Role"
#   principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
#   #principal_id         = "0b721d88-5586-4765-83ce-e609a355c644"
# }
# create website contributor role assignment at resourcegroup scope with managed identity
resource "azurerm_role_assignment" "website_contributor" {
  scope                = var.resourcegroup_id
  role_definition_name = "Website Contributor"
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
}
# create key vault administrator role assignment at subscription scope with managed identity
resource "azurerm_role_assignment" "mi_kv_admin" {
  scope              = var.key_vault_id
  principal_id       = azurerm_user_assigned_identity.app_assigned.principal_id
  role_definition_name = "Key Vault Administrator"
}
#create key vault administrator role assignment at subscription scope with current user active directory
resource "azurerm_role_assignment" "current" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_client_config.current.object_id
}
# # Pull access for the app service
# resource "azurerm_role_assignment" "prod_app_service_acr_pull" {
#   scope                = var.acr_id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
# }
resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = var.resourcegroup_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
}
# create fedrated app role assignment at subscription scope with managed identity
resource "azurerm_federated_identity_credential" "petstore_assigned_identity_dev" {
  name                = "dev-petstore-fed-identity"
  resource_group_name = var.resourcegroup
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.app_assigned.id
  subject             = "repo:oreakinodidi98/petstore:ref:refs/heads/development"
}
# create fedrated app role assignment at subscription scope with managed identity
resource "azurerm_federated_identity_credential" "petstore_assigned_identity_main" {
  name                = "main-petstore-fed-identity"
  resource_group_name = var.resourcegroup
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.app_assigned.id
  subject             = "repo:oreakinodidi98/petstore:ref:refs/heads/main"
}