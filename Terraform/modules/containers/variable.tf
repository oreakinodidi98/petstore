variable "location" {
}
variable "resourcegroup" {
}
variable "ssh_public_key" {
  description = "Absolute path to the SSH public key file"
  default = "~/.ssh/id_rsa.pub"
}
variable "resourcegroup_id" {
}
variable "aks_cluster_name" {
  type = string
}
variable "acr_name" {
  type = string
}
variable "system_node_count" {
  description = "The number of system nodes for the AKS cluster"
  type        = number
}
variable "min_node_count" {
  description = "The min number of system nodes for the AKS cluster"
  type        = number
}
variable "max_node_count" {
  description = "The max number of system nodes for the AKS cluster"
  type        = number
}
variable "log_analytics_id" {
}
variable "vm_sku" {
}
variable "managed_identity_id" {
}
variable "managed_identity_principal_id" {
}
variable "managed_identity_name" {
}
variable "admin_groups" {
  type = list(string)
  default = [ "21b860b5-43ea-42ca-bec8-68793176c3c5" ]
}
variable "k8s_namespace" {
  type = string
  default = "app"
}
variable "k8s_service_account_name" {
  type = string
  default = "workload"
}