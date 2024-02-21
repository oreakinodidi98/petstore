##################################### default outputs ########################
output "rg_name" {
  value = azurerm_resource_group.resourcegroup.name
}
output "rg_location" {
  value = azurerm_resource_group.resourcegroup.location
}
########################## output for managed identity ##############################
output "managed_identity_client_id" {
  value = module.managed_identity.managed_identity_client_id
}
output "managed_identity_principal_id" {
  value = module.managed_identity.managed_identity_principal_id
}
output "managed_identity_id" {
  value = module.managed_identity.managed_identity_id
}
########################## output for container ##############################
output "acr_name" {
  value = module.containers.acr_name
}
output "acr_id" {
  value = module.containers.acr_id
}
output "acr_login_server" {
  value = module.containers.acr_login_server
}
output "aks_name" {
  value = module.containers.aks_name
}
output "aks_id" {
  value = module.containers.aks_id
}
output "aks_fqdn" {
  value = module.containers.aks_fqdn
}
output "kube_config_path" {
  value = module.containers.kube_config_path
}
output "client_certificate_path" {
  value = module.containers.client_certificate_path
}
output "recommend_kube_config" {
  value = module.containers.recommend_kube_config
}
output "registry_password" {
  value     = module.containers.registry_password
  sensitive = true
}
output "registry_username" {
  value     = module.containers.registry_username
  sensitive = true
}

########################## output for monitoring ##############################
output "log_analytics_id" {
  value = module.monitoring.azurerm_log_analytics_workspace_id
}
output "log_analytics_name" {
  value = module.monitoring.azurerm_log_analytics_workspace_name
}
output "instrumentation_key" {
  value     = module.monitoring.instrumentation_key
  sensitive = true
}
output "appinsights_id" {
  value = module.monitoring.app_id
}
########################## output for appservice ##############################
output "dev_app_svc_id" {
  value = module.appservice.dev_app_svc_id
}
output "prod_app_svc_id" {
  value = module.appservice.prod_app_svc_id

}
output "app_svc_plan_name" {
  value = module.appservice.app_svc_plan_name
}
output "dev_app_svc_name" {
  value = module.appservice.dev_app_svc_name
}
output "prod_app_svc_name" {
  value = module.appservice.prod_app_svc_name

}
output "app_svc_plan_id" {
  value = module.appservice.app_svc_plan_id
}
########################## output for keyvault ##############################
output "key_vault_id" {
  value = module.keyvault.key_vault_id
}
output "key_vault_name" {
  value     = module.keyvault.key_vault_name
  sensitive = true
}

########################## output for keyvault secret ##############################
output "secret_docker_password" {
  value     = module.kv_secret_docker_password.value
  sensitive = true
}
output "secret_docker_username" {
  value     = module.kv_secret_docker_username.value
  sensitive = true
}