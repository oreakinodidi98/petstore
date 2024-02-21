resource "azurerm_key_vault_secret" "acr_secret" {
  name         = var.name
  value        = var.value
  key_vault_id = var.key_vault_id
    content_type = ""

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}