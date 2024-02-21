
output "key_vault_id" {
  value = azurerm_key_vault.kv.id
  description = "value for key_vault_id"
}
output "key_vault_name" {
  description = "Key Vault Name"
  value       = azurerm_key_vault.kv.name
  sensitive   = true
}

