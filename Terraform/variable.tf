##################################### default variables ########################
variable "resourcegroup" {
  description = "value for resourcegroup"
  type        = string
  default     = "rg-petstore-01"
}
variable "location" {
  description = "value for location"
  type        = string
  default     = "UK South"
}
variable "naming_prefix" {
  description = "The naming prefix for all resources in this example"
  type        = string
  default     = "petstore"
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "Ore Akin"
    demo        = "petstore"
  }
}
##################################### managed identity variables ########################
variable "owner_username" {
  description = "The username of the owner of the AKS cluster"
  type        = string
  default     = "oreakinodidi_microsoft.com#EXT#@fdpo.onmicrosoft.com"
}
##################################### container Variables ########################
#AKS variables
variable "aks_cluster_name" {
  type    = string
  default = "oa-pet-aks"
}
variable "acr_name" {
  type    = string
  default = "oapetacr"
}
variable "system_node_count" {
  description = "The number of system nodes for the AKS cluster"
  type        = number
  default     = 3
}
variable "min_node_count" {
  description = "The number of system nodes for the AKS cluster"
  type        = number
  default     = 3
}
variable "max_node_count" {
  description = "The number of system nodes for the AKS cluster"
  type        = number
  default     = 8
}
variable "vm_sku" {
  description = "The SKU of the Virtual Machine"
  type        = string
  default     = "Standard_D2as_v5"
  #default     = "Standard_DS2_v2"
}
##################################### logs variables ########################
#log analytics variables
variable "env_name" {
  description = "Name of Environment"
  type        = string
  default     = "petstore-aks"
}
variable "log_analytics_workspace_sku" {
  description = "The pricing SKU of the Log Analytics workspace."
  default     = "PerGB2018"
}
##################################### Keyvault variables ########################
variable "sku_name" {
  type        = string
  description = "Select Standard or Premium SKU"
  default     = "premium"
}
variable "enabled_for_deployment" {
  type        = string
  description = "Allow Azure Virtual Machines to retrieve certificates stored as secrets from the Azure Key Vault"
  default     = "true"
}

variable "enabled_for_disk_encryption" {
  type        = string
  description = "Allow Azure Disk Encryption to retrieve secrets from the Azure Key Vault and unwrap keys"
  default     = "true"
}

variable "enabled_for_template_deployment" {
  type        = string
  description = "Allow Azure Resource Manager to retrieve secrets from the Azure Key Vault"
  default     = "true"
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