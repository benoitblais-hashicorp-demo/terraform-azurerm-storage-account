provider "azurerm" {
  features {}
}

run "invalid_name" {
  command = plan

  variables {
    name                = "Bad_Name"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
  }

  expect_failures = [
    var.name,
  ]
}

run "invalid_account_kind" {
  command = plan

  variables {
    name                              = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location                          = "eastus"
    resource_group_name               = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    account_kind                      = "BadKind"
    infrastructure_encryption_enabled = false
  }

  expect_failures = [
    var.account_kind,
  ]
}

run "invalid_account_replication_type" {
  command = plan

  variables {
    name                     = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location                 = "eastus"
    resource_group_name      = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    account_replication_type = "BAD"
  }

  expect_failures = [
    var.account_replication_type,
  ]
}

run "invalid_provisioned_billing_model_version" {
  command = plan

  variables {
    name                              = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location                          = "eastus"
    resource_group_name               = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    provisioned_billing_model_version = "V3"
  }

  expect_failures = [
    var.provisioned_billing_model_version,
  ]
}

run "invalid_min_tls_version" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    min_tls_version     = "TLS1_4"
  }

  expect_failures = [
    var.min_tls_version,
  ]
}

run "invalid_is_hns_enabled_combo" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    account_tier        = "Premium"
    account_kind        = "StorageV2"
    is_hns_enabled      = true
  }

  expect_failures = [
    var.is_hns_enabled,
  ]
}

run "invalid_nfsv3_enabled_combo" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    nfsv3_enabled       = true
    is_hns_enabled      = false
  }

  expect_failures = [
    var.nfsv3_enabled,
  ]
}

run "invalid_customer_managed_key_ids" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    customer_managed_key = {
      key_vault_id              = "bad"
      user_assigned_identity_id = "bad"
    }
  }

  expect_failures = [
    var.customer_managed_key,
  ]
}

run "invalid_identity_userassigned_missing_ids" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    identity = {
      type = "UserAssigned"
    }
  }

  expect_failures = [
    var.identity,
  ]
}

run "invalid_blob_properties_delete_retention_days" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    blob_properties = {
      delete_retention_policy = {
        days                     = 0
        permanent_delete_enabled = false
      }
    }
  }

  expect_failures = [
    var.blob_properties,
  ]
}

run "invalid_queue_properties_cors_method" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    queue_properties = {
      cors_rule = [
        {
          allowed_headers    = ["*"]
          allowed_methods    = ["TRACE"]
          allowed_origins    = ["*"]
          exposed_headers    = ["*"]
          max_age_in_seconds = 60
        }
      ]
    }
  }

  expect_failures = [
    var.queue_properties,
  ]
}

run "invalid_routing_choice" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    routing = {
      choice = "Bad"
    }
  }

  expect_failures = [
    var.routing,
  ]
}

run "invalid_queue_encryption_key_type" {
  command = plan

  variables {
    name                              = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location                          = "eastus"
    resource_group_name               = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    account_kind                      = "Storage"
    queue_encryption_key_type         = "Account"
    infrastructure_encryption_enabled = false
  }

  expect_failures = [
    var.queue_encryption_key_type,
  ]
}

run "invalid_infrastructure_encryption_enabled" {
  command = plan

  variables {
    name                              = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location                          = "eastus"
    resource_group_name               = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    account_kind                      = "Storage"
    account_tier                      = "Standard"
    infrastructure_encryption_enabled = true
  }

  expect_failures = [
    var.infrastructure_encryption_enabled,
  ]
}

run "invalid_sas_policy_format" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    sas_policy = {
      expiration_period = "1:00:00"
    }
  }

  expect_failures = [
    var.sas_policy,
  ]
}

run "invalid_allowed_copy_scope" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    allowed_copy_scope  = "Public"
  }

  expect_failures = [
    var.allowed_copy_scope,
  ]
}

run "invalid_sftp_without_hns" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    sftp_enabled        = true
    is_hns_enabled      = false
  }

  expect_failures = [
    var.sftp_enabled,
  ]
}

run "invalid_dns_endpoint_type" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    dns_endpoint_type   = "Bad"
  }

  expect_failures = [
    var.dns_endpoint_type,
  ]
}

run "invalid_storage_blobs_type" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    storage_blobs = [
      {
        name = "blob${substr(replace(uuid(), "-", ""), 0, 8)}"
        type = "Bad"
      }
    ]
  }

  expect_failures = [
    var.storage_blobs,
  ]
}

run "invalid_storage_containers_access" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    storage_containers = [
      {
        name                  = "cont${substr(replace(uuid(), "-", ""), 0, 8)}"
        container_access_type = "public"
      }
    ]
  }

  expect_failures = [
    var.storage_containers,
  ]
}

run "invalid_encryption_scope_keyvault_missing_key" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    encryption_scopes = [
      {
        name   = "scope${substr(replace(uuid(), "-", ""), 0, 8)}"
        source = "Microsoft.KeyVault"
      }
    ]
  }

  expect_failures = [
    var.encryption_scopes,
  ]
}

run "invalid_management_policy_enabled_no_rules" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    management_policy = {
      enabled = true
      rules   = []
    }
  }

  expect_failures = [
    var.management_policy,
  ]
}

run "invalid_storage_tables_access_policy_missing" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    storage_tables = [
      {
        name = "table${substr(replace(uuid(), "-", ""), 0, 8)}"
        acl = [
          {
            id = "policy${substr(replace(uuid(), "-", ""), 0, 8)}"
            access_policy = {
              start       = ""
              expiry      = ""
              permissions = ""
            }
          }
        ]
      }
    ]
  }

  expect_failures = [
    var.storage_tables,
  ]
}

run "invalid_private_endpoint_request_message" {
  command = plan

  variables {
    name                = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location            = "eastus"
    resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
    private_endpoint = {
      name                = "pe-${substr(replace(uuid(), "-", ""), 0, 8)}"
      location            = "eastus"
      resource_group_name = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-${substr(replace(uuid(), "-", ""), 0, 8)}/providers/Microsoft.Network/virtualNetworks/vnet-${substr(replace(uuid(), "-", ""), 0, 8)}/subnets/snet-${substr(replace(uuid(), "-", ""), 0, 8)}"
      private_service_connection = {
        name                           = "psc-${substr(replace(uuid(), "-", ""), 0, 8)}"
        is_manual_connection           = false
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-${substr(replace(uuid(), "-", ""), 0, 8)}/providers/Microsoft.Storage/storageAccounts/st${substr(replace(uuid(), "-", ""), 0, 10)}"
        request_message                = "hello"
      }
    }
  }

  expect_failures = [
    var.private_endpoint,
  ]
}