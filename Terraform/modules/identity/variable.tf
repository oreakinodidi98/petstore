variable "location" {
}
variable "naming_prefix" {
}
variable "resourcegroup" {
}
 variable "resourcegroup_id" {
 }
  variable "acr_id" {
 }
 variable "key_vault_id" {
 }
variable "service_principal_name" {
   description = "the name of the service principal"
  type = string
}
variable "owner_username" {
  description = "The username of the owner of the AKS cluster"
  type        = string
}