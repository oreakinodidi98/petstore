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
########################## output for service principal ##############################
#output service principle name
output "service_principal_name" {
    description = "value for service principal name"
    value = azuread_service_principal.main.display_name
}

#output service principle object id
output "service_principal_object_id" {
    description = "value for service principal object id"
    value = azuread_service_principal.main.object_id
}

#output service principle tenant id
output "service_principal_tenant_id" {
  description = "value for service principal tenant id"
  value= azuread_service_principal.main.application_tenant_id
}

#output service principle application id
output "service_principal_applicaiton_id" {
    description = "value for application id for SP"
    #value = azuread_service_principal.main.application_id
    value = azuread_service_principal.main.client_id
}

#output service principle client id
output "service_principal_client_id" {
    description = "value for application client id"
    #value = azuread_application.main.application_id
    value = azuread_application.main.client_id
}

#output client secret
output "client_secret" {
    description = "value of client secret"
    value = azuread_service_principal_password.main.value
    sensitive = true
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