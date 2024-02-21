output "azurerm_log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.aks.name
}
output "azurerm_log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.aks.id
}
output "instrumentation_key" {
  value = azurerm_application_insights.app_svc.instrumentation_key
}
output "app_id" {
  value = azurerm_application_insights.app_svc.app_id
}