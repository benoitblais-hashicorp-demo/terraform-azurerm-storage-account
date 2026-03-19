output "private_endpoint_id" {
  description = "The private endpoint ID if created."
  value       = try(azurerm_private_endpoint.this["default"].id, null)
}

output "storage_account_customer_managed_key_id" {
  description = "The customer managed key resource ID if created."
  value       = try(azurerm_storage_account_customer_managed_key.this["default"].id, null)
}

output "storage_account_id" {
  description = "The storage account resource ID."
  value       = azurerm_storage_account.this.id
}

output "storage_account_local_user_ids" {
  description = "Map of local user IDs keyed by local user name."
  value       = { for name, user in azurerm_storage_account_local_user.this : name => user.id }
}

output "storage_account_name" {
  description = "The storage account name."
  value       = azurerm_storage_account.this.name
}

output "storage_account_network_rules_id" {
  description = "The storage account network rules resource ID if created."
  value       = try(azurerm_storage_account_network_rules.this["default"].id, null)
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "storage_account_primary_queue_endpoint" {
  description = "The primary queue endpoint."
  value       = azurerm_storage_account.this.primary_queue_endpoint
}

output "storage_account_primary_table_endpoint" {
  description = "The primary table endpoint."
  value       = azurerm_storage_account.this.primary_table_endpoint
}

output "storage_account_primary_web_endpoint" {
  description = "The primary web endpoint."
  value       = azurerm_storage_account.this.primary_web_endpoint
}

output "storage_blob_ids" {
  description = "Map of storage blob IDs keyed by <container>/<name>."
  value       = { for key, blob in azurerm_storage_blob.this : key => blob.id }
}

output "storage_container_ids" {
  description = "Map of storage container IDs keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.id }
}

output "storage_encryption_scope_ids" {
  description = "Map of storage encryption scope IDs keyed by scope name."
  value       = { for name, scope in azurerm_storage_encryption_scope.this : name => scope.id }
}

output "storage_management_policy_id" {
  description = "The storage management policy ID if created."
  value       = try(azurerm_storage_management_policy.this["default"].id, null)
}

output "storage_queue_ids" {
  description = "Map of storage queue IDs keyed by queue name."
  value       = { for name, queue in azurerm_storage_queue.this : name => queue.id }
}

output "storage_table_ids" {
  description = "Map of storage table IDs keyed by table name."
  value       = { for name, table in azurerm_storage_table.this : name => table.id }
}