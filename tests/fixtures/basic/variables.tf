variable "location" {
  description = "Azure region for the test resource group and storage account."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name used by the test fixture."
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name used by the test fixture."
  type        = string
}
