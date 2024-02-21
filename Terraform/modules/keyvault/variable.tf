
variable "location" {
  type = string
}
variable "resourcegroup" {
  type = string
}
variable "managed_identity_principal_id" {
}
variable "naming_prefix" {
}
variable "sku_name" {

}
variable "enabled_for_deployment" {
  type = string
}

variable "enabled_for_disk_encryption" {
    type = string
}

variable "enabled_for_template_deployment" {
    type = string
}
# variable "kv-key-permissions-full" {
#   type        = list(string)
#   description = "List of full key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey."
#   default = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge",
#   "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
# }

# variable "kv-secret-permissions-full" {
#   type        = list(string)
#   description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
#   default     = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
# }

# variable "kv-certificate-permissions-full" {
#   type        = list(string)
#   description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
#   default = ["create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers",
#   "managecontacts", "manageissuers", "purge", "recover", "setissuers", "update", "backup", "restore"]
# }

# variable "kv-storage-permissions-full" {
#   type        = list(string)
#   description = "List of full storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
#   default = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas",
#   "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
# }
# variable "kv-key-permissions-read" {
#   type        = list(string)
#   description = "List of read key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey"
#   default     = ["get", "list"]
# }

# variable "kv-secret-permissions-read" {
#   type        = list(string)
#   description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
#   default     = ["get", "list"]
# }

# variable "kv-certificate-permissions-read" {
#   type        = list(string)
#   description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
#   default     = ["get", "getissuers", "list", "listissuers"]
# }

# variable "kv-storage-permissions-read" {
#   type        = list(string)
#   description = "List of read storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
#   default     = ["get", "getsas", "list", "listsas"]
# }
