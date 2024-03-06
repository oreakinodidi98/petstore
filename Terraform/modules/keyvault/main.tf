# create a secret in the keyvault
data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}
data "azurerm_subscription" "current" {}
#create managed identity
resource "azurerm_key_vault" "kv" {
  name                       = "${var.naming_prefix}-keyvault02"
  location                   = var.location
  resource_group_name        = var.resourcegroup
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = 7
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

}
resource "azurerm_key_vault_access_policy" "Keyvault_terraform_user" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.managed_identity_principal_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  storage_permissions = [ "Get" ]
}
resource "azurerm_key_vault_access_policy" "petstore_terraform_subscribtion_kv" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  storage_permissions = [ "Get", "List", "Set", "Delete" ]
  certificate_permissions = [ "Create", "Get", "List", "Delete", "Import", "Update"]
}

# resource "azurerm_role_assignment" "terraform_keyvault_access" {
#   scope                = azurerm_key_vault.kv.id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = data.azurerm_client_config.current.object_id
# }
resource "azurerm_key_vault_secret" "secret_acr_docker" {
  name         = var.name
  value        = var.value
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [ azurerm_key_vault_access_policy.petstore_terraform_subscribtion_kv ]
}
resource "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "ssh-public-key"
  value        = var.tls_public_key
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [ azurerm_key_vault_access_policy.petstore_terraform_subscribtion_kv ]
}
resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "ssh-private-key"
  value        = var.tls_private_key
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [ azurerm_key_vault_access_policy.petstore_terraform_subscribtion_kv ]
}