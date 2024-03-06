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
#subscription output
output "subscribtion_id" {
    description = "value for subscription id"
    value = data.azurerm_subscription.current.subscription_id
}
#tenant id output
output "arm_tenant_id" {
    description = "value for tenant id"
    value = data.azuread_client_config.current.tenant_id
}