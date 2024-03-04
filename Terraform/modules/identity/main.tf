data "azurerm_subscription" "current" {}
#data source that is reading the data from client config. using that data in the creation of the managed identity
data "azuread_client_config" "current" {}
data "azurerm_client_config" "current" {}

# data "azuread_user" "admin_user" {
#   user_principal_name = var.owner_username
# }
# locals {
#         app_owners = [
#         data.azuread_client_config.current.object_id,
#         data.azuread_user.admin_user.object_id
# ]
# }
# ############################################
# #create azure ad group. makes owner the current terraform user
# resource "azuread_group" "petstore_admins" {
#   display_name = "${var.naming_prefix}_admins"
#   description = "petstore-dev"
#   security_enabled = true
#   owners = [ data.azurerm_client_config.current.object_id ]
# }
# # # create members of the group
# resource "azuread_group_member" "admin_member" {
#   group_object_id  = azuread_group.petstore_admins.id
#   member_object_id = data.azuread_user.admin_user.id
# }
#create managed identity
resource "azurerm_user_assigned_identity" "app_assigned" {
  name                = "petstore-identity"
  location            = var.location
  resource_group_name = var.resourcegroup
}
resource "azurerm_role_assignment" "mi_roledefinition_role_assignment" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/Microsoft.Authorization/roleAssignments/write"
  principal_id       = azurerm_user_assigned_identity.app_assigned.principal_id
}
resource "azurerm_role_assignment" "roledefinition_role_assignment" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/Microsoft.Authorization/roleAssignments/write"
  principal_id       = data.azurerm_client_config.current.object_id
}
#create role assighnment at RG scope with managed identity
resource "azurerm_role_assignment" "role_rg" {
  scope                = var.resourcegroup_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
}
# create contributor role assignment at subscription scope with managed identity
resource "azurerm_role_assignment" "contributor_role_assignment" {
  scope                = data.azurerm_subscription.current.id
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
  role_definition_name = "Contributor"
}
# create website contributor role assignment at resourcegroup scope with managed identity
resource "azurerm_role_assignment" "website_contributor" {
  scope                = var.resourcegroup_id
  role_definition_name = "Website Contributor"
  principal_id         = azurerm_user_assigned_identity.app_assigned.principal_id
}
# create key vault administrator role assignment at subscription scope with managed identity
resource "azurerm_role_assignment" "mi_kv_admin" {
  scope              = data.azurerm_subscription.current.id
  principal_id       = azurerm_user_assigned_identity.app_assigned.principal_id
  role_definition_name = "Key Vault Administrator"
}
# create key vault administrator role assignment at subscription scope with current user active directory
# resource "azurerm_role_assignment" "current" {
#   scope                = data.azurerm_subscription.current.id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = data.azuread_client_config.current.object_id
# }
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

############################################
# locals {
#   admin_users = ["oreakinodidi@gmail.com", "admin@MngENVMCAP059812.onmicrosoft.com" ]
# }
# data "azuread_user" "admin_user" {
#   count = length(local.admin_users)
#   user_principal_name = local.admin_users[count.index]
# }
# resource "azuread_group_member" "admin_member" {
#   count = length(local.admin_users)
#   group_object_id  = azuread_group.petstore_admins.id
#   member_object_id = data.azuread_user.admin_user[count.index].id
# }

#### service principal i am using needs application permission of group.readwrite.all permission and user.read.All permission