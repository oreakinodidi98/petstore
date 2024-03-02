variable "location" {
}
variable "resourcegroup" {
}
variable "naming_prefix" {
}
variable "tags" {
description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
variable "instrumentation_key" {
}
variable "managed_identity_client_id" {
}
variable "managed_identity_id" {
}
variable "acr_name" {
}
variable "registry_password" {
}