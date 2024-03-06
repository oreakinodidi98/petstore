resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.env_name}-loga"
  location            = var.location
  resource_group_name = var.resourcegroup
  sku                 = var.log_analytics_workspace_sku
 retention_in_days   = 30
}
resource "azurerm_monitor_workspace" "aks_monitor_workspace" {
  name                = "${var.env_name}-monitor"
  resource_group_name = var.resourcegroup
  location            = var.location
}
resource "azurerm_log_analytics_solution" "aks-containerinsights" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.aks.location
  resource_group_name   = var.resourcegroup
  workspace_resource_id = azurerm_log_analytics_workspace.aks.id
  workspace_name        = azurerm_log_analytics_workspace.aks.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_application_insights" "app_svc" {
  name                = "${var.naming_prefix}-app-insight"
  location            = var.location
  resource_group_name = var.resourcegroup
  application_type    = "web"
  workspace_id = azurerm_log_analytics_workspace.aks.id
}
resource "azurerm_application_insights_smart_detection_rule" "example" {
  name                    = "Slow server response time"
  application_insights_id = azurerm_application_insights.app_svc.id
  enabled                 = false
}
resource "azurerm_monitor_action_group" "actiongroup" {
  name                = "${var.naming_prefix}-actiongroup"
  resource_group_name = var.resourcegroup
  short_name          = "Action"

    email_receiver {
    name          = "sendtoadmin"
    email_address = "oreakinodidi@microsoft.com"
  }
}
resource "azurerm_monitor_metric_alert" "metric" {
  name                = "${var.naming_prefix}-metricalert"
  resource_group_name = var.resourcegroup
  scopes              = [var.appsvcid]
  description         = "Action will be triggered when Transactions count is greater than 50."

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 2
  }

  action {
    action_group_id = azurerm_monitor_action_group.actiongroup.id
  }
}
resource "azurerm_load_test" "loadtest" {
  location            = var.location
  name                = "${var.naming_prefix}-loadtest"
  resource_group_name = var.resourcegroup
}
resource "azurerm_storage_account" "pet_storage" {
  name                     = "devoa12storage"
  resource_group_name      = var.resourcegroup
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
# resource "azurerm_monitor_diagnostic_setting" "kv_diagnostic_settings" {
#   name               = "${random_pet.prefix.id}-diagnostic-settings"
#   target_resource_id = var.key_vault_id
#   storage_account_id = azurerm_storage_account.pet_storage.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
#   log_analytics_destination_type = "Dedicated"

#   enabled_log {
#     category = "AuditEvent"
#     #category_group = "audit"

#     retention_policy {
#       enabled = true
#     }
#   }

#   enabled_log {
#     category = "AzurePolicyEvaluationDetails"

#     retention_policy {
#       enabled = true
#     }
#   }

#   metric {
#     category = "AllMetrics"

#     retention_policy {
#       enabled = true
#     }
#   }
# }
