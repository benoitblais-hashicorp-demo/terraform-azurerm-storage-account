resource "azurerm_storage_account" "this" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_kind                      = var.account_kind
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  access_tier                       = var.access_tier
  provisioned_billing_model_version = var.provisioned_billing_model_version
  edge_zone                         = var.edge_zone
  https_traffic_only_enabled        = var.https_traffic_only_enabled
  min_tls_version                   = var.min_tls_version
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  allowed_copy_scope                = var.allowed_copy_scope
  dns_endpoint_type                 = var.dns_endpoint_type
  queue_encryption_key_type         = var.queue_encryption_key_type
  table_encryption_key_type         = var.table_encryption_key_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  is_hns_enabled                    = var.is_hns_enabled
  nfsv3_enabled                     = var.nfsv3_enabled
  sftp_enabled                      = var.sftp_enabled
  local_user_enabled                = var.local_user_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  tags                              = var.tags

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain == null ? [] : [var.custom_domain]

    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }

  dynamic "routing" {
    for_each = var.routing == null ? [] : [var.routing]

    content {
      publish_internet_endpoints  = routing.value.publish_internet_endpoints
      publish_microsoft_endpoints = routing.value.publish_microsoft_endpoints
      choice                      = routing.value.choice
    }
  }

  dynamic "sas_policy" {
    for_each = var.sas_policy == null ? [] : [var.sas_policy]

    content {
      expiration_period = sas_policy.value.expiration_period
      expiration_action = try(sas_policy.value.expiration_action, null)
    }
  }

  dynamic "immutability_policy" {
    for_each = var.immutability_policy == null ? [] : [var.immutability_policy]

    content {
      allow_protected_append_writes = immutability_policy.value.allow_protected_append_writes
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
      state                         = immutability_policy.value.state
    }
  }

  dynamic "blob_properties" {
    for_each = var.blob_properties == null ? [] : [var.blob_properties]

    content {
      versioning_enabled            = try(blob_properties.value.versioning_enabled, null)
      change_feed_enabled           = try(blob_properties.value.change_feed_enabled, null)
      change_feed_retention_in_days = try(blob_properties.value.change_feed_retention_in_days, null)
      default_service_version       = try(blob_properties.value.default_service_version, null)
      last_access_time_enabled      = try(blob_properties.value.last_access_time_enabled, null)

      dynamic "delete_retention_policy" {
        for_each = try(blob_properties.value.delete_retention_policy == null ? [] : [blob_properties.value.delete_retention_policy], [])

        content {
          days                     = delete_retention_policy.value.days
          permanent_delete_enabled = delete_retention_policy.value.permanent_delete_enabled
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = try(blob_properties.value.container_delete_retention_policy == null ? [] : [blob_properties.value.container_delete_retention_policy], [])

        content {
          days = container_delete_retention_policy.value.days
        }
      }

      dynamic "restore_policy" {
        for_each = try(blob_properties.value.restore_policy == null ? [] : [blob_properties.value.restore_policy], [])

        content {
          days = restore_policy.value.days
        }
      }

      dynamic "cors_rule" {
        for_each = try(blob_properties.value.cors_rule, [])

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_properties == null ? [] : [var.queue_properties]

    content {
      dynamic "logging" {
        for_each = try(queue_properties.value.logging == null ? [] : [queue_properties.value.logging], [])

        content {
          delete                = logging.value.delete
          read                  = logging.value.read
          write                 = logging.value.write
          version               = logging.value.version
          retention_policy_days = logging.value.retention_policy_days
        }
      }

      dynamic "hour_metrics" {
        for_each = try(queue_properties.value.hour_metrics == null ? [] : [queue_properties.value.hour_metrics], [])

        content {
          enabled               = hour_metrics.value.enabled
          include_apis          = hour_metrics.value.include_apis
          version               = hour_metrics.value.version
          retention_policy_days = hour_metrics.value.retention_policy_days
        }
      }

      dynamic "minute_metrics" {
        for_each = try(queue_properties.value.minute_metrics == null ? [] : [queue_properties.value.minute_metrics], [])

        content {
          enabled               = minute_metrics.value.enabled
          include_apis          = minute_metrics.value.include_apis
          version               = minute_metrics.value.version
          retention_policy_days = minute_metrics.value.retention_policy_days
        }
      }

      dynamic "cors_rule" {
        for_each = try(queue_properties.value.cors_rule, [])

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = var.static_website == null ? [] : [var.static_website]

    content {
      index_document     = try(static_website.value.index_document, null)
      error_404_document = try(static_website.value.error_404_document, null)
    }
  }
}

resource "azurerm_storage_account_customer_managed_key" "this" {
  for_each = var.storage_account_customer_managed_key == null ? {} : { "default" = var.storage_account_customer_managed_key }

  storage_account_id           = azurerm_storage_account.this.id
  key_vault_key_id             = each.value.key_vault_key_id
  user_assigned_identity_id    = each.value.user_assigned_identity_id
  federated_identity_client_id = each.value.federated_identity_client_id
}

resource "azurerm_storage_account_local_user" "this" {
  for_each = { for user in var.local_users : user.name => user }

  name                 = each.value.name
  storage_account_id   = azurerm_storage_account.this.id
  ssh_key_enabled      = each.value.ssh_key_enabled
  ssh_password_enabled = each.value.ssh_password_enabled
  home_directory       = each.value.home_directory

  dynamic "ssh_authorized_key" {
    for_each = each.value.ssh_authorized_keys

    content {
      key         = ssh_authorized_key.value.key
      description = ssh_authorized_key.value.description
    }
  }

  dynamic "permission_scope" {
    for_each = each.value.permission_scopes

    content {
      permissions {
        read   = permission_scope.value.permissions.read
        create = permission_scope.value.permissions.create
        write  = permission_scope.value.permissions.write
        delete = permission_scope.value.permissions.delete
        list   = permission_scope.value.permissions.list
      }

      service       = permission_scope.value.service
      resource_name = permission_scope.value.resource_name
    }
  }
}

resource "azurerm_storage_account_network_rules" "this" {
  for_each = var.network_rules == null ? {} : { "default" = var.network_rules }

  storage_account_id         = azurerm_storage_account.this.id
  default_action             = try(each.value.default_action, null)
  bypass                     = try(each.value.bypass, null)
  ip_rules                   = try(each.value.ip_rules, null)
  virtual_network_subnet_ids = try(each.value.virtual_network_subnet_ids, null)

  dynamic "private_link_access" {
    for_each = try(each.value.private_link_access, [])

    content {
      endpoint_resource_id = private_link_access.value.endpoint_resource_id
      endpoint_tenant_id   = try(private_link_access.value.endpoint_tenant_id, null)
    }
  }
}

resource "azurerm_storage_blob" "this" {
  for_each = { for blob in var.storage_blobs : "${coalesce(blob.container_name, blob.name)}/${blob.name}" => blob }

  name                   = each.value.name
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = coalesce(each.value.container_name, each.value.name)
  type                   = coalesce(each.value.type, "Block")
  size                   = try(each.value.size, null)
  access_tier            = try(each.value.access_tier, null)
  cache_control          = try(each.value.cache_control, null)
  content_type           = try(each.value.content_type, null)
  content_md5            = try(each.value.content_md5, null)
  encryption_scope       = try(each.value.encryption_scope, null)
  source                 = try(each.value.source, null)
  source_content         = try(each.value.source_content, null)
  source_uri             = try(each.value.source_uri, null)
  parallelism            = try(each.value.parallelism, null)
  metadata               = try(each.value.metadata, null)

  depends_on = [azurerm_storage_container.this]

}

resource "azurerm_storage_container" "this" {
  for_each = { for container in var.storage_containers : container.name => container }

  name                              = each.value.name
  storage_account_id                = azurerm_storage_account.this.id
  container_access_type             = try(each.value.container_access_type, null)
  default_encryption_scope          = try(each.value.default_encryption_scope, null)
  encryption_scope_override_enabled = try(each.value.encryption_scope_override_enabled, null)
  metadata                          = try(each.value.metadata, null)
}

resource "azurerm_storage_encryption_scope" "this" {
  for_each = { for scope in var.encryption_scopes : scope.name => scope }

  name                               = each.value.name
  storage_account_id                 = azurerm_storage_account.this.id
  source                             = each.value.source
  key_vault_key_id                   = each.value.key_vault_key_id
  infrastructure_encryption_required = each.value.infrastructure_encryption_required
}

resource "azurerm_storage_management_policy" "this" {
  for_each = var.management_policy.enabled ? { "default" = var.management_policy } : {}

  storage_account_id = azurerm_storage_account.this.id

  dynamic "rule" {
    for_each = try(each.value.rules, [])

    content {
      name    = rule.value.name
      enabled = rule.value.enabled

      filters {
        blob_types   = rule.value.filters.blob_types
        prefix_match = rule.value.filters.prefix_match

        dynamic "match_blob_index_tag" {
          for_each = try(rule.value.filters.match_blob_index_tag, [])

          content {
            name      = match_blob_index_tag.value.name
            operation = match_blob_index_tag.value.operation
            value     = match_blob_index_tag.value.value
          }
        }
      }

      actions {
        dynamic "base_blob" {
          for_each = rule.value.actions.base_blob == null ? [] : [rule.value.actions.base_blob]

          content {
            tier_to_cool_after_days_since_modification_greater_than        = try(base_blob.value.tier_to_cool_after_days_since_modification_greater_than, null)
            tier_to_archive_after_days_since_modification_greater_than     = try(base_blob.value.tier_to_archive_after_days_since_modification_greater_than, null)
            tier_to_archive_after_days_since_last_tier_change_greater_than = try(base_blob.value.tier_to_archive_after_days_since_last_tier_change_greater_than, null)
            tier_to_cool_after_days_since_last_access_time_greater_than    = try(base_blob.value.tier_to_cool_after_days_since_last_access_time_greater_than, null)
            delete_after_days_since_modification_greater_than              = try(base_blob.value.delete_after_days_since_modification_greater_than, null)
            delete_after_days_since_last_access_time_greater_than          = try(base_blob.value.delete_after_days_since_last_access_time_greater_than, null)
            auto_tier_to_hot_from_cool_enabled                             = try(base_blob.value.auto_tier_to_hot_from_cool_enabled, null)
          }
        }

        dynamic "snapshot" {
          for_each = rule.value.actions.snapshot == null ? [] : [rule.value.actions.snapshot]

          content {
            change_tier_to_cool_after_days_since_creation    = try(snapshot.value.change_tier_to_cool_after_days_since_creation, null)
            change_tier_to_archive_after_days_since_creation = try(snapshot.value.change_tier_to_archive_after_days_since_creation, null)
            delete_after_days_since_creation_greater_than    = try(snapshot.value.delete_after_days_since_creation_greater_than, null)
          }
        }

        dynamic "version" {
          for_each = rule.value.actions.version == null ? [] : [rule.value.actions.version]

          content {
            change_tier_to_cool_after_days_since_creation    = try(version.value.change_tier_to_cool_after_days_since_creation, null)
            change_tier_to_archive_after_days_since_creation = try(version.value.change_tier_to_archive_after_days_since_creation, null)
            delete_after_days_since_creation                 = try(version.value.delete_after_days_since_creation, null)
          }
        }
      }
    }
  }
}

resource "azurerm_storage_queue" "this" {
  for_each = { for queue in var.storage_queues : queue.name => queue }

  name               = each.value.name
  storage_account_id = azurerm_storage_account.this.id
  metadata           = try(each.value.metadata, null)
}

resource "azurerm_storage_table" "this" {
  for_each = { for table in var.storage_tables : table.name => table }

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name

  dynamic "acl" {
    for_each = try(each.value.acl, [])

    content {
      id = acl.value.id

      dynamic "access_policy" {
        for_each = acl.value.access_policy == null ? [] : [acl.value.access_policy]

        content {
          start       = access_policy.value.start
          expiry      = access_policy.value.expiry
          permissions = access_policy.value.permissions
        }
      }
    }
  }
}

resource "azurerm_private_endpoint" "this" {
  for_each = var.private_endpoint == null ? {} : { "default" = var.private_endpoint }

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = try(each.value.custom_network_interface_name, null)
  tags                          = try(each.value.tags, null)

  private_service_connection {
    name                              = each.value.private_service_connection.name
    is_manual_connection              = each.value.private_service_connection.is_manual_connection
    private_connection_resource_id    = each.value.private_service_connection.private_connection_resource_alias == null ? coalesce(try(each.value.private_service_connection.private_connection_resource_id, null), azurerm_storage_account.this.id) : null
    private_connection_resource_alias = try(each.value.private_service_connection.private_connection_resource_alias, null)
    subresource_names                 = try(each.value.private_service_connection.subresource_names, null)
    request_message                   = try(each.value.private_service_connection.request_message, null)
  }

  dynamic "private_dns_zone_group" {
    for_each = try(each.value.private_dns_zone_group, [])

    content {
      name                 = private_dns_zone_group.value.name
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }

  dynamic "ip_configuration" {
    for_each = try(each.value.ip_configuration, [])

    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = try(ip_configuration.value.subresource_name, null)
      member_name        = try(ip_configuration.value.member_name, null)
    }
  }
}
