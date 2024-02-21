data "azurerm_subscription" "current" {}
#data source that is reading the data from client config. using that data in the creation of the managed identity
data "azuread_client_config" "current" {}
# create a secret in the keyvault
data "azurerm_client_config" "current" {}
#create managed identity
data "azuread_service_principal" "current" {
  display_name = "AzureResumeOA"
}
resource "azurerm_user_assigned_identity" "app_assigned" {
  name                = "petstore-identity"
  location            = var.location
  resource_group_name = var.resourcegroup
}
#create role assighnment at RG scope with managed identity
resource "azurerm_role_assignment" "role_rg" {
  scope                = var.resourcegroup_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
}
#create role assignment for acr pull with managed identity
resource "azurerm_role_assignment" "mi_role_acrpull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
}
resource "azurerm_role_assignment" "mi_role_acrpush" {
  scope                = var.acr_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
}
# create contributor role assignment at subscription scope with managed identity
# resource "azurerm_role_assignment" "contributor_role_assignment" {
#   scope                = data.azurerm_subscription.current.id
#   principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
#   role_definition_name = "Contributor"
# }
resource "azurerm_role_assignment" "website_contributor" {
  scope                = var.resourcegroup_id
  role_definition_name = "Website Contributor"
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
}
resource "azurerm_role_assignment" "mi_kv_admin" {
  scope              = var.key_vault_id
  principal_id       = azurerm_user_assigned_identity.app_assigned.principal_id
  role_definition_name = "Key Vault Administrator"
}
resource "azurerm_role_assignment" "az_kv_admin" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "sp_kv_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_service_principal.current.object_id
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