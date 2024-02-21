# linux app service plan
resource "azurerm_service_plan" "app_svc_plan" {
  name                = "${var.naming_prefix}-app-plan"
  resource_group_name = var.resourcegroup
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}
#linux app service
resource "azurerm_linux_web_app" "prod_app_svc" {
  name                = "${var.naming_prefix}-app-service"
  resource_group_name = var.resourcegroup
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_svc_plan.id
        # Configuration for Azure Application Insights
  app_settings = {
      "APPINSIGHTS_INSTRUMENTATIONKEY" = var.instrumentation_key 
      "WEBSITE_RUN_FROM_PACKAGE" = 1
      "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = true
      }
  site_config {
    // other site_config settings...
   # linux_fx_version = "DOTNET|7.0"
    remote_debugging_enabled = true
    always_on = true
    remote_debugging_version = "VS2019"
  }
   identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [var.managed_identity_id]  
}
}
resource "azurerm_linux_web_app_slot" "dev_app_svc" {
  name           = "TestEnv"
  app_service_id = azurerm_linux_web_app.prod_app_svc.id
  app_settings = {
      "APPINSIGHTS_INSTRUMENTATIONKEY" = var.instrumentation_key
      "WEBSITE_RUN_FROM_PACKAGE" = 1
      "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = true 
      "SCM_DO_BUILD_DURING_DEPLOYMENT" = true
      #"WEBSITE_HTTPLOGGING_RETENTION_DAYS" = 3
      "DOCKER_REGISTRY_SERVER_URL" = "https://${var.acr_name}.azurecr.io"
      "DOCKER_ENABLE_CI" = "true"
      }
  site_config {
    remote_debugging_enabled = true
    always_on = true
    remote_debugging_version = "VS2019"
    #auto_swap_slot_name = azurerm_linux_web_app.prod_app_svc.name
    container_registry_use_managed_identity= true
    container_registry_managed_identity_client_id = var.managed_identity_client_id
      application_stack{
    docker_image_name = "${var.acr_name}.azurecr.io/petstoreapp:latest"
    }
  }
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [var.managed_identity_id]  
}
 depends_on = [ azurerm_linux_web_app.prod_app_svc ]
}
resource "azurerm_web_app_active_slot" "app_active_slot" {
  slot_id = azurerm_linux_web_app_slot.dev_app_svc.id
}