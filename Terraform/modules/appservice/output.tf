output "prod_app_svc_name" {
  value = azurerm_linux_web_app.prod_app_svc.name
}
output "dev_app_svc_name" {
  value = azurerm_linux_web_app_slot.dev_app_svc.name
}
output "prod_app_svc_id" {
  value = azurerm_linux_web_app.prod_app_svc.id
}
output "dev_app_svc_id" {
  value = azurerm_linux_web_app_slot.dev_app_svc.id
}
output "app_svc_plan_name" {
  value = azurerm_service_plan.app_svc_plan.name
}
output "app_svc_plan_id" {
  value = azurerm_service_plan.app_svc_plan.id
}