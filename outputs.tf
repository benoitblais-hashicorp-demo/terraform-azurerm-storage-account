output "private_endpoint" {
  description = "The private endpoint resource if created."
  value       = try(azurerm_private_endpoint.this["default"], null)
}

output "private_endpoint_custom_dns_configs" {
  description = "The private endpoint custom DNS configs if created."
  value       = try(azurerm_private_endpoint.this["default"].custom_dns_configs, null)
}

output "private_endpoint_id" {
  description = "The private endpoint ID if created."
  value       = try(azurerm_private_endpoint.this["default"].id, null)
}

output "private_endpoint_ip_configuration" {
  description = "The private endpoint IP configuration blocks if created."
  value       = try(azurerm_private_endpoint.this["default"].ip_configuration, null)
}

output "private_endpoint_network_interface" {
  description = "The private endpoint network interface block if created."
  value       = try(azurerm_private_endpoint.this["default"].network_interface, null)
}

output "private_endpoint_network_interface_id" {
  description = "The private endpoint network interface ID if created."
  value       = try(azurerm_private_endpoint.this["default"].network_interface[0].id, null)
}

output "private_endpoint_network_interface_name" {
  description = "The private endpoint network interface name if created."
  value       = try(azurerm_private_endpoint.this["default"].network_interface[0].name, null)
}

output "private_endpoint_private_dns_zone_configs" {
  description = "The private endpoint private DNS zone configs if created."
  value       = try(azurerm_private_endpoint.this["default"].private_dns_zone_configs, null)
}

output "private_endpoint_private_service_connection_private_ip_address" {
  description = "The private endpoint private service connection private IP address if created."
  value       = try(azurerm_private_endpoint.this["default"].private_service_connection[0].private_ip_address, null)
}

output "storage_account" {
  description = "The storage account resource."
  value       = azurerm_storage_account.this
  sensitive   = true
}

output "storage_account_customer_managed_key" {
  description = "The customer managed key resource if created."
  value       = try(azurerm_storage_account_customer_managed_key.this["default"], null)
}

output "storage_account_customer_managed_key_id" {
  description = "The customer managed key resource ID if created."
  value       = try(azurerm_storage_account_customer_managed_key.this["default"].id, null)
}

output "storage_account_customer_managed_key_key_vault_key_id" {
  description = "The customer managed key Key Vault key ID if created."
  value       = try(azurerm_storage_account_customer_managed_key.this["default"].key_vault_key_id, null)
}

output "storage_account_customer_managed_key_storage_account_id" {
  description = "The customer managed key storage account ID if created."
  value       = try(azurerm_storage_account_customer_managed_key.this["default"].storage_account_id, null)
}

output "storage_account_customer_managed_key_user_assigned_identity_id" {
  description = "The customer managed key user-assigned identity ID if created."
  value       = try(azurerm_storage_account_customer_managed_key.this["default"].user_assigned_identity_id, null)
}

output "storage_account_customer_managed_key_federated_identity_client_id" {
  description = "The customer managed key federated identity client ID if created."
  value       = try(azurerm_storage_account_customer_managed_key.this["default"].federated_identity_client_id, null)
}

output "storage_account_id" {
  description = "The storage account resource ID."
  value       = azurerm_storage_account.this.id
}

output "storage_account_identity" {
  description = "The storage account identity block."
  value       = try(azurerm_storage_account.this.identity, null)
}

output "storage_account_identity_principal_id" {
  description = "The storage account identity principal ID."
  value       = try(azurerm_storage_account.this.identity[0].principal_id, null)
}

output "storage_account_identity_tenant_id" {
  description = "The storage account identity tenant ID."
  value       = try(azurerm_storage_account.this.identity[0].tenant_id, null)
}

output "storage_account_local_users" {
  description = "Map of storage account local users keyed by local user name."
  value       = azurerm_storage_account_local_user.this
  sensitive   = true
}

output "storage_account_local_user_ids" {
  description = "Map of local user IDs keyed by local user name."
  value       = { for name, user in azurerm_storage_account_local_user.this : name => user.id }
}

output "storage_account_local_user_passwords" {
  description = "Map of local user passwords keyed by local user name."
  value       = { for name, user in azurerm_storage_account_local_user.this : name => user.password }
  sensitive   = true
}

output "storage_account_local_user_sids" {
  description = "Map of local user SIDs keyed by local user name."
  value       = { for name, user in azurerm_storage_account_local_user.this : name => user.sid }
}

output "storage_account_name" {
  description = "The storage account name."
  value       = azurerm_storage_account.this.name
}

output "storage_account_network_rules" {
  description = "The storage account network rules resource if created."
  value       = try(azurerm_storage_account_network_rules.this["default"], null)
}

output "storage_account_network_rules_id" {
  description = "The storage account network rules resource ID if created."
  value       = try(azurerm_storage_account_network_rules.this["default"].id, null)
}

output "storage_account_primary_access_key" {
  description = "The storage account primary access key."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "storage_account_primary_blob_connection_string" {
  description = "The storage account primary blob connection string."
  value       = azurerm_storage_account.this.primary_blob_connection_string
  sensitive   = true
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "storage_account_primary_blob_host" {
  description = "The primary blob host."
  value       = azurerm_storage_account.this.primary_blob_host
}

output "storage_account_primary_blob_internet_endpoint" {
  description = "The primary blob internet endpoint."
  value       = azurerm_storage_account.this.primary_blob_internet_endpoint
}

output "storage_account_primary_blob_internet_host" {
  description = "The primary blob internet host."
  value       = azurerm_storage_account.this.primary_blob_internet_host
}

output "storage_account_primary_blob_microsoft_endpoint" {
  description = "The primary blob Microsoft endpoint."
  value       = azurerm_storage_account.this.primary_blob_microsoft_endpoint
}

output "storage_account_primary_blob_microsoft_host" {
  description = "The primary blob Microsoft host."
  value       = azurerm_storage_account.this.primary_blob_microsoft_host
}

output "storage_account_primary_connection_string" {
  description = "The storage account primary connection string."
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

output "storage_account_primary_dfs_endpoint" {
  description = "The primary DFS endpoint."
  value       = azurerm_storage_account.this.primary_dfs_endpoint
}

output "storage_account_primary_dfs_host" {
  description = "The primary DFS host."
  value       = azurerm_storage_account.this.primary_dfs_host
}

output "storage_account_primary_dfs_internet_endpoint" {
  description = "The primary DFS internet endpoint."
  value       = azurerm_storage_account.this.primary_dfs_internet_endpoint
}

output "storage_account_primary_dfs_internet_host" {
  description = "The primary DFS internet host."
  value       = azurerm_storage_account.this.primary_dfs_internet_host
}

output "storage_account_primary_dfs_microsoft_endpoint" {
  description = "The primary DFS Microsoft endpoint."
  value       = azurerm_storage_account.this.primary_dfs_microsoft_endpoint
}

output "storage_account_primary_dfs_microsoft_host" {
  description = "The primary DFS Microsoft host."
  value       = azurerm_storage_account.this.primary_dfs_microsoft_host
}

output "storage_account_primary_file_endpoint" {
  description = "The primary file endpoint."
  value       = azurerm_storage_account.this.primary_file_endpoint
}

output "storage_account_primary_file_host" {
  description = "The primary file host."
  value       = azurerm_storage_account.this.primary_file_host
}

output "storage_account_primary_file_internet_endpoint" {
  description = "The primary file internet endpoint."
  value       = azurerm_storage_account.this.primary_file_internet_endpoint
}

output "storage_account_primary_file_internet_host" {
  description = "The primary file internet host."
  value       = azurerm_storage_account.this.primary_file_internet_host
}

output "storage_account_primary_file_microsoft_endpoint" {
  description = "The primary file Microsoft endpoint."
  value       = azurerm_storage_account.this.primary_file_microsoft_endpoint
}

output "storage_account_primary_file_microsoft_host" {
  description = "The primary file Microsoft host."
  value       = azurerm_storage_account.this.primary_file_microsoft_host
}

output "storage_account_primary_location" {
  description = "The storage account primary location."
  value       = azurerm_storage_account.this.primary_location
}

output "storage_account_primary_queue_endpoint" {
  description = "The primary queue endpoint."
  value       = azurerm_storage_account.this.primary_queue_endpoint
}

output "storage_account_primary_queue_host" {
  description = "The primary queue host."
  value       = azurerm_storage_account.this.primary_queue_host
}

output "storage_account_primary_queue_microsoft_endpoint" {
  description = "The primary queue Microsoft endpoint."
  value       = azurerm_storage_account.this.primary_queue_microsoft_endpoint
}

output "storage_account_primary_queue_microsoft_host" {
  description = "The primary queue Microsoft host."
  value       = azurerm_storage_account.this.primary_queue_microsoft_host
}

output "storage_account_primary_table_endpoint" {
  description = "The primary table endpoint."
  value       = azurerm_storage_account.this.primary_table_endpoint
}

output "storage_account_primary_table_host" {
  description = "The primary table host."
  value       = azurerm_storage_account.this.primary_table_host
}

output "storage_account_primary_table_microsoft_endpoint" {
  description = "The primary table Microsoft endpoint."
  value       = azurerm_storage_account.this.primary_table_microsoft_endpoint
}

output "storage_account_primary_table_microsoft_host" {
  description = "The primary table Microsoft host."
  value       = azurerm_storage_account.this.primary_table_microsoft_host
}

output "storage_account_primary_web_endpoint" {
  description = "The primary web endpoint."
  value       = azurerm_storage_account.this.primary_web_endpoint
}

output "storage_account_primary_web_host" {
  description = "The primary web host."
  value       = azurerm_storage_account.this.primary_web_host
}

output "storage_account_primary_web_internet_endpoint" {
  description = "The primary web internet endpoint."
  value       = azurerm_storage_account.this.primary_web_internet_endpoint
}

output "storage_account_primary_web_internet_host" {
  description = "The primary web internet host."
  value       = azurerm_storage_account.this.primary_web_internet_host
}

output "storage_account_primary_web_microsoft_endpoint" {
  description = "The primary web Microsoft endpoint."
  value       = azurerm_storage_account.this.primary_web_microsoft_endpoint
}

output "storage_account_primary_web_microsoft_host" {
  description = "The primary web Microsoft host."
  value       = azurerm_storage_account.this.primary_web_microsoft_host
}

output "storage_account_secondary_access_key" {
  description = "The storage account secondary access key."
  value       = azurerm_storage_account.this.secondary_access_key
  sensitive   = true
}

output "storage_account_secondary_blob_connection_string" {
  description = "The storage account secondary blob connection string."
  value       = azurerm_storage_account.this.secondary_blob_connection_string
  sensitive   = true
}

output "storage_account_secondary_blob_endpoint" {
  description = "The secondary blob endpoint."
  value       = azurerm_storage_account.this.secondary_blob_endpoint
}

output "storage_account_secondary_blob_host" {
  description = "The secondary blob host."
  value       = azurerm_storage_account.this.secondary_blob_host
}

output "storage_account_secondary_blob_internet_endpoint" {
  description = "The secondary blob internet endpoint."
  value       = azurerm_storage_account.this.secondary_blob_internet_endpoint
}

output "storage_account_secondary_blob_internet_host" {
  description = "The secondary blob internet host."
  value       = azurerm_storage_account.this.secondary_blob_internet_host
}

output "storage_account_secondary_blob_microsoft_endpoint" {
  description = "The secondary blob Microsoft endpoint."
  value       = azurerm_storage_account.this.secondary_blob_microsoft_endpoint
}

output "storage_account_secondary_blob_microsoft_host" {
  description = "The secondary blob Microsoft host."
  value       = azurerm_storage_account.this.secondary_blob_microsoft_host
}

output "storage_account_secondary_connection_string" {
  description = "The storage account secondary connection string."
  value       = azurerm_storage_account.this.secondary_connection_string
  sensitive   = true
}

output "storage_account_secondary_dfs_endpoint" {
  description = "The secondary DFS endpoint."
  value       = azurerm_storage_account.this.secondary_dfs_endpoint
}

output "storage_account_secondary_dfs_host" {
  description = "The secondary DFS host."
  value       = azurerm_storage_account.this.secondary_dfs_host
}

output "storage_account_secondary_dfs_internet_endpoint" {
  description = "The secondary DFS internet endpoint."
  value       = azurerm_storage_account.this.secondary_dfs_internet_endpoint
}

output "storage_account_secondary_dfs_internet_host" {
  description = "The secondary DFS internet host."
  value       = azurerm_storage_account.this.secondary_dfs_internet_host
}

output "storage_account_secondary_dfs_microsoft_endpoint" {
  description = "The secondary DFS Microsoft endpoint."
  value       = azurerm_storage_account.this.secondary_dfs_microsoft_endpoint
}

output "storage_account_secondary_dfs_microsoft_host" {
  description = "The secondary DFS Microsoft host."
  value       = azurerm_storage_account.this.secondary_dfs_microsoft_host
}

output "storage_account_secondary_file_endpoint" {
  description = "The secondary file endpoint."
  value       = azurerm_storage_account.this.secondary_file_endpoint
}

output "storage_account_secondary_file_host" {
  description = "The secondary file host."
  value       = azurerm_storage_account.this.secondary_file_host
}

output "storage_account_secondary_file_internet_endpoint" {
  description = "The secondary file internet endpoint."
  value       = azurerm_storage_account.this.secondary_file_internet_endpoint
}

output "storage_account_secondary_file_internet_host" {
  description = "The secondary file internet host."
  value       = azurerm_storage_account.this.secondary_file_internet_host
}

output "storage_account_secondary_file_microsoft_endpoint" {
  description = "The secondary file Microsoft endpoint."
  value       = azurerm_storage_account.this.secondary_file_microsoft_endpoint
}

output "storage_account_secondary_file_microsoft_host" {
  description = "The secondary file Microsoft host."
  value       = azurerm_storage_account.this.secondary_file_microsoft_host
}

output "storage_account_secondary_location" {
  description = "The storage account secondary location."
  value       = azurerm_storage_account.this.secondary_location
}

output "storage_account_secondary_queue_endpoint" {
  description = "The secondary queue endpoint."
  value       = azurerm_storage_account.this.secondary_queue_endpoint
}

output "storage_account_secondary_queue_host" {
  description = "The secondary queue host."
  value       = azurerm_storage_account.this.secondary_queue_host
}

output "storage_account_secondary_queue_microsoft_endpoint" {
  description = "The secondary queue Microsoft endpoint."
  value       = azurerm_storage_account.this.secondary_queue_microsoft_endpoint
}

output "storage_account_secondary_queue_microsoft_host" {
  description = "The secondary queue Microsoft host."
  value       = azurerm_storage_account.this.secondary_queue_microsoft_host
}

output "storage_account_secondary_table_endpoint" {
  description = "The secondary table endpoint."
  value       = azurerm_storage_account.this.secondary_table_endpoint
}

output "storage_account_secondary_table_host" {
  description = "The secondary table host."
  value       = azurerm_storage_account.this.secondary_table_host
}

output "storage_account_secondary_table_microsoft_endpoint" {
  description = "The secondary table Microsoft endpoint."
  value       = azurerm_storage_account.this.secondary_table_microsoft_endpoint
}

output "storage_account_secondary_table_microsoft_host" {
  description = "The secondary table Microsoft host."
  value       = azurerm_storage_account.this.secondary_table_microsoft_host
}

output "storage_account_secondary_web_endpoint" {
  description = "The secondary web endpoint."
  value       = azurerm_storage_account.this.secondary_web_endpoint
}

output "storage_account_secondary_web_host" {
  description = "The secondary web host."
  value       = azurerm_storage_account.this.secondary_web_host
}

output "storage_account_secondary_web_internet_endpoint" {
  description = "The secondary web internet endpoint."
  value       = azurerm_storage_account.this.secondary_web_internet_endpoint
}

output "storage_account_secondary_web_internet_host" {
  description = "The secondary web internet host."
  value       = azurerm_storage_account.this.secondary_web_internet_host
}

output "storage_account_secondary_web_microsoft_endpoint" {
  description = "The secondary web Microsoft endpoint."
  value       = azurerm_storage_account.this.secondary_web_microsoft_endpoint
}

output "storage_account_secondary_web_microsoft_host" {
  description = "The secondary web Microsoft host."
  value       = azurerm_storage_account.this.secondary_web_microsoft_host
}

output "storage_blob" {
  description = "Map of storage blob resources keyed by <container>/<name>."
  value       = azurerm_storage_blob.this
}

output "storage_blob_ids" {
  description = "Map of storage blob IDs keyed by <container>/<name>."
  value       = { for key, blob in azurerm_storage_blob.this : key => blob.id }
}

output "storage_blob_urls" {
  description = "Map of storage blob URLs keyed by <container>/<name>."
  value       = { for key, blob in azurerm_storage_blob.this : key => blob.url }
}

output "storage_container" {
  description = "Map of storage container resources keyed by container name."
  value       = azurerm_storage_container.this
}

output "storage_container_has_immutability_policy" {
  description = "Map of container immutability policy flags keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.has_immutability_policy }
}

output "storage_container_has_legal_hold" {
  description = "Map of container legal hold flags keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.has_legal_hold }
}

output "storage_container_ids" {
  description = "Map of storage container IDs keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.id }
}

output "storage_container_resource_manager_ids" {
  description = "Map of storage container resource manager IDs keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.resource_manager_id }
}

output "storage_encryption_scope" {
  description = "Map of storage encryption scope resources keyed by scope name."
  value       = azurerm_storage_encryption_scope.this
}

output "storage_encryption_scope_ids" {
  description = "Map of storage encryption scope IDs keyed by scope name."
  value       = { for name, scope in azurerm_storage_encryption_scope.this : name => scope.id }
}

output "storage_management_policy" {
  description = "The storage management policy resource if created."
  value       = try(azurerm_storage_management_policy.this["default"], null)
}

output "storage_management_policy_id" {
  description = "The storage management policy ID if created."
  value       = try(azurerm_storage_management_policy.this["default"].id, null)
}

output "storage_queue" {
  description = "Map of storage queue resources keyed by queue name."
  value       = azurerm_storage_queue.this
}

output "storage_queue_ids" {
  description = "Map of storage queue IDs keyed by queue name."
  value       = { for name, queue in azurerm_storage_queue.this : name => queue.id }
}

output "storage_queue_resource_manager_ids" {
  description = "Map of storage queue resource manager IDs keyed by queue name."
  value       = { for name, queue in azurerm_storage_queue.this : name => queue.resource_manager_id }
}

output "storage_queue_urls" {
  description = "Map of storage queue URLs keyed by queue name."
  value       = { for name, queue in azurerm_storage_queue.this : name => queue.url }
}

output "storage_table" {
  description = "Map of storage table resources keyed by table name."
  value       = azurerm_storage_table.this
}

output "storage_table_ids" {
  description = "Map of storage table IDs keyed by table name."
  value       = { for name, table in azurerm_storage_table.this : name => table.id }
}

output "storage_table_resource_manager_ids" {
  description = "Map of storage table resource manager IDs keyed by table name."
  value       = { for name, table in azurerm_storage_table.this : name => table.resource_manager_id }
}