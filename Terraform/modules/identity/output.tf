########################## output for managed identity ##############################
output "managed_identity_client_id" {
  value = azurerm_user_assigned_identity.app_assigned.client_id
}
output "managed_identity_principal_id" {
  value = azurerm_user_assigned_identity.app_assigned.principal_id
}
output "managed_identity_id" {
  value = azurerm_user_assigned_identity.app_assigned.id
}
output "managed_identity_name" {
  value = azurerm_user_assigned_identity.app_assigned.name
}
output "group_object_id" {
  value = azuread_group.petstore_admins.object_id
}