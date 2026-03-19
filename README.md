<!-- BEGIN_TF_DOCS -->
# Azure Storage Account Terraform Module

Terraform module to provision an Azure Storage Account with optional networking, encryption, data plane objects, and private endpoint integration.

## Permissions

To provision the Azure resources managed by this module, the identity running Terraform needs permissions such as:

- Storage account management (create/update/delete).
- Storage containers, blobs, queues, and tables management.
- Storage account network rules and private endpoint management.
- Key Vault key access for customer-managed keys (if used).
- Resource group read and write access where resources are created.

## Authentications

Authenticate to Azure using one of the supported AzureRM provider methods:

- Azure CLI (`az login`) for local development.
- Service principal with client secret or certificate.
- Managed identity when running in Azure.
- Environment variables (`ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`).

## Features

- Create and configure an Azure Storage Account with secure defaults.
- Optional identity, customer-managed keys, encryption scopes, and management policies.
- Optional local users and network rules.
- Optional data plane resources: containers, blobs, queues, and tables.
- Optional private endpoint with DNS zone group association.

## Usage example

```hcl
module "storage_account" {
  source  = "app.terraform.io/benoitblais-hashicorp/terraform-azurerm-storage-account/azurerm"
  version = "0.0.0"

  name                = "stexample123"
  location            = "eastus"
  resource_group_name = "rg-example"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.13.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.64.0)

## Modules

No modules.

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: (Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: (Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier)

Description: (Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are `Hot`, `Cool`, `Cold` and `Premium`. Defaults to `Hot`.

Type: `string`

Default: `"Hot"`

### <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind)

Description: (Optional) Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`.

Type: `string`

Default: `"StorageV2"`

### <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type)

Description: (Optional)  Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`. Changing this forces a new resource to be created when types `LRS`, `GRS` and `RAGRS` are changed to `ZRS`, `GZRS` or `RAGZRS` and vice versa.

Type: `string`

Default: `"LRS"`

### <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier)

Description: (Optional) Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`. For BlockBlobStorage and FileStorage accounts only `Premium` is valid. Changing this forces a new resource to be created.

Type: `string`

Default: `"Standard"`

### <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public)

Description: (Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to `false`.

Type: `bool`

Default: `false`

### <a name="input_allowed_copy_scope"></a> [allowed\_copy\_scope](#input\_allowed\_copy\_scope)

Description: (Optional) Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Possible values are `AAD` and `PrivateLink`.

Type: `string`

Default: `null`

### <a name="input_blob_properties"></a> [blob\_properties](#input\_blob\_properties)

Description:   (Optional) A `blob_properties` block as defined below.  
    cors\_rule : (Optional) A `cors_rule` block as defined below.  
      allowed\_headers : (Required) A list of headers that are allowed to be a part of the cross-origin request.  
      allowed\_methods : (Required) A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.  
      allowed\_origins : (Required) A list of origin domains that will be allowed by CORS.  
      exposed\_headers : (Required) A list of response headers that are exposed to CORS clients.  
      max\_age\_in\_seconds : (Required) The number of seconds the client should cache a preflight response.  
    delete\_retention\_policy : (Optional) A `delete_retention_policy` block as defined below.  
      days : (Optional) Specifies the number of days that the blob should be retained, between 1 and 365 days.  
      permanent\_delete\_enabled : (Optional) Indicates whether permanent deletion of the soft deleted blob versions and snapshots is allowed.  
    restore\_policy : (Optional) A `restore_policy` block as defined below.  
      days : (Required) Specifies the number of days that the blob can be restored, between 1 and 365 days. This must be less than the days specified for delete\_retention\_policy.  
	  versioning\_enabled : (Optional) Is versioning enabled?  
	  change\_feed\_enabled : (Optional) Is the blob service properties for change feed events enabled?  
	  change\_feed\_retention\_in\_days : (Optional) The duration of change feed events retention in days. Possible values are between `1` and `146000` days.  
    default\_service\_version : (Optional) The API Version which should be used by default for requests to the Data Plane API if an incoming request doesn't specify an API Version.  
	  last\_access\_time\_enabled : (Optional) Is the last access time based tracking enabled?  
	  container\_delete\_retention\_policy : (Optional) A `container_delete_retention_policy` block as defined below.

Type:

```hcl
object({
    cors_rule = optional(list(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })), [])
    delete_retention_policy = optional(object({
      days                     = number
      permanent_delete_enabled = bool
    }))
    restore_policy = optional(object({
      days = number
    }))
    versioning_enabled            = optional(bool)
    change_feed_enabled           = optional(bool)
    change_feed_retention_in_days = optional(number)
    default_service_version       = optional(string)
    last_access_time_enabled      = optional(bool)
    container_delete_retention_policy = optional(object({
      days = number
    }))
  })
```

Default: `null`

### <a name="input_cross_tenant_replication_enabled"></a> [cross\_tenant\_replication\_enabled](#input\_cross\_tenant\_replication\_enabled)

Description: (Optional) Should cross Tenant replication be enabled? Defaults to `false`.

Type: `bool`

Default: `false`

### <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain)

Description:   (Optional) A `custom_domain` block as documented below.  
    name : (Required) The Custom Domain Name to use for the Storage Account, which will be validated by Azure.  
    use\_subdomain : (Optional) Should the Custom Domain Name be validated by using indirect CNAME validation?

Type:

```hcl
object({
    name          = string
    use_subdomain = optional(bool)
  })
```

Default: `null`

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description:   (Optional) A `customer_managed_key` block as documented below.  
    key\_vault\_id :  (Optional) The ID of the Key Vault Key, supplying a version-less key ID will enable auto-rotation of this key.  
    user\_assigned\_identity\_id : (Required) The ID of a user assigned identity.

Type:

```hcl
object({
    key_vault_id              = optional(string)
    user_assigned_identity_id = optional(string)
  })
```

Default: `null`

### <a name="input_default_to_oauth_authentication"></a> [default\_to\_oauth\_authentication](#input\_default\_to\_oauth\_authentication)

Description: (Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. Defaults to `false`.

Type: `bool`

Default: `false`

### <a name="input_dns_endpoint_type"></a> [dns\_endpoint\_type](#input\_dns\_endpoint\_type)

Description: (Optional) Specifies which DNS endpoint type to use. Possible values are `Standard` and `AzureDnsZone`. Defaults to `Standard`. Changing this forces a new resource to be created.

Type: `string`

Default: `"Standard"`

### <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone)

Description: (Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created.

Type: `string`

Default: `null`

### <a name="input_encryption_scopes"></a> [encryption\_scopes](#input\_encryption\_scopes)

Description:   (Optional) Storage encryption scopes to create.  
    name : (Required) The name which should be used for this Storage Encryption Scope. Changing this forces a new Storage Encryption Scope to be created.  
    source : (Required) The source of the Storage Encryption Scope. Possible values are `Microsoft.KeyVault` and `Microsoft.Storage`.  
    key\_vault\_key\_id : (Optional) The ID of the Key Vault Key. Required when `source` is `Microsoft.KeyVault`.  
    infrastructure\_encryption\_required : (Optional) Is a secondary layer of encryption with Platform Managed Keys for data applied? Changing this forces a new resource to be created.

Type:

```hcl
list(object({
    name                               = string
    source                             = string
    key_vault_key_id                   = optional(string)
    infrastructure_encryption_required = optional(bool)
  }))
```

Default: `[]`

### <a name="input_https_traffic_only_enabled"></a> [https\_traffic\_only\_enabled](#input\_https\_traffic\_only\_enabled)

Description: (Optional) Boolean flag which forces HTTPS if enabled. Defaults to `true`.

Type: `bool`

Default: `true`

### <a name="input_identity"></a> [identity](#input\_identity)

Description:   (Optional) A `identity` block as documented below.  
    type : (Required) Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, or `SystemAssigned, UserAssigned`.  
    identity\_ids : (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account.

Type:

```hcl
object({
    type         = optional(string)
    identity_ids = optional(list(string), [])
  })
```

Default: `null`

### <a name="input_immutability_policy"></a> [immutability\_policy](#input\_immutability\_policy)

Description:   (Optional) An `immutability_policy` block as defined below. Changing this forces a new resource to be created.  
    allow\_protected\_append\_writes : (Required) When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance.  
    period\_since\_creation\_in\_days : (Required) The immutability period for the blobs in the container since the policy creation, in days.  
    state : (Required) Defines the mode of the policy. Possible values are `Disabled`, `Unlocked`, and `Locked`.

Type:

```hcl
object({
    allow_protected_append_writes = optional(bool)
    period_since_creation_in_days = optional(number)
    state                         = optional(string)
  })
```

Default: `null`

### <a name="input_infrastructure_encryption_enabled"></a> [infrastructure\_encryption\_enabled](#input\_infrastructure\_encryption\_enabled)

Description: (Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created.

Type: `bool`

Default: `true`

### <a name="input_is_hns_enabled"></a> [is\_hns\_enabled](#input\_is\_hns\_enabled)

Description: (Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2. Changing this forces a new resource to be created. Defaults to `false`.

Type: `bool`

Default: `false`

### <a name="input_large_file_share_enabled"></a> [large\_file\_share\_enabled](#input\_large\_file\_share\_enabled)

Description: (Optional) Are Large File Shares Enabled?

Type: `bool`

Default: `false`

### <a name="input_local_user_enabled"></a> [local\_user\_enabled](#input\_local\_user\_enabled)

Description: (Optional) Is Local User Enabled?

Type: `bool`

Default: `false`

### <a name="input_local_users"></a> [local\_users](#input\_local\_users)

Description:   (Optional) Local users to create on the storage account.  
    name : (Required) The name which should be used for this Storage Account Local User.  
    home\_directory : (Optional) The home directory of the Storage Account Local User.  
    permission\_scopes : (Optional) One or more `permission_scope` blocks as defined below.  
      permissions : (Required) A `permissions` block as defined below.  
        create : (Optional) Specifies if the Local User has the create permission for this scope. Defaults to `false`.  
        delete : (Optional) Specifies if the Local User has the delete permission for this scope. Defaults to `false`.  
        list : (Optional) Specifies if the Local User has the list permission for this scope. Defaults to `false`.  
        read : (Optional) Specifies if the Local User has the read permission for this scope. Defaults to `false`.  
        write : (Optional) Specifies if the Local User has the write permission for this scope. Defaults to `false`.  
      resource\_name : (Required) The container name (when `service` is set to `blob`) or the file share name (when `service` is set to `file`), used by the Storage Account Local User.  
      service : (Required) The storage service used by this Storage Account Local User. Possible values are `blob` and `file`.  
    ssh\_authorized\_keys : (Optional) One or more `ssh_authorized_key` blocks as defined below.  
      key : (Required) The public key value of this SSH authorized key.  
      description : (Optional) The description of this SSH authorized key.  
    ssh\_key\_enabled : (Optional) Specifies whether SSH Key Authentication is enabled. Defaults to `false`.  
    ssh\_password\_enabled : (Optional) Specifies whether SSH Password Authentication is enabled. Defaults to `false`.

Type:

```hcl
list(object({
    name                 = string
    ssh_key_enabled      = optional(bool)
    ssh_password_enabled = optional(bool)
    home_directory       = optional(string)
    ssh_authorized_keys = optional(list(object({
      key         = string
      description = optional(string)
    })), [])
    permission_scopes = list(object({
      permissions = object({
        read   = optional(bool)
        create = optional(bool)
        write  = optional(bool)
        delete = optional(bool)
        list   = optional(bool)
      })
      service       = string
      resource_name = string
    }))
  }))
```

Default: `[]`

### <a name="input_management_policy"></a> [management\_policy](#input\_management\_policy)

Description:   (Optional) Storage management policy configuration.  
    rules : (Optional) One or more `rule` blocks as defined below.  
      name : (Required) The name of the rule. Rule name is case-sensitive. It must be unique within a policy.  
      enabled : (Required) Boolean to specify whether the rule is enabled.  
      filters : (Required) A `filters` block as defined below.  
        blob\_types : (Required) Valid options are `blockBlob` and `appendBlob`.  
        prefix\_match : (Optional) An array of strings for prefixes to be matched.  
        match\_blob\_index\_tag : (Optional) A `match_blob_index_tag` block as defined below.  
          name : (Required) The filter tag name used for tag based filtering for blob objects.  
          operation : (Optional) The comparison operator used for object comparison and filtering. Possible value is `==`.  
          value : (Required) The filter tag value used for tag based filtering for blob objects.  
      actions : (Required) An `actions` block as defined below.  
        base\_blob : (Optional) A `base_blob` block as defined below.  
					tier\_to\_cool\_after\_days\_since\_modification\_greater\_than : (Optional) Age in days after last modification to tier blobs to cool storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_cool\_after\_days\_since\_last\_access\_time\_greater\_than : (Optional) Age in days after last access time to tier blobs to cool storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_cool\_after\_days\_since\_creation\_greater\_than : (Optional) Age in days after creation to cool storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_archive\_after\_days\_since\_modification\_greater\_than : (Optional) Age in days after last modification to tier blobs to archive storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_archive\_after\_days\_since\_last\_access\_time\_greater\_than : (Optional) Age in days after last access time to tier blobs to archive storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_archive\_after\_days\_since\_creation\_greater\_than : (Optional) Age in days after creation to archive storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_archive\_after\_days\_since\_last\_tier\_change\_greater\_than : (Optional) Age in days after last tier change to archive blobs. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_cold\_after\_days\_since\_modification\_greater\_than : (Optional) Age in days after last modification to tier blobs to cold storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_cold\_after\_days\_since\_last\_access\_time\_greater\_than : (Optional) Age in days after last access time to tier blobs to cold storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_cold\_after\_days\_since\_creation\_greater\_than : (Optional) Age in days after creation to cold storage. Must be between `0` and `99999`. Defaults to `-1`.  
					delete\_after\_days\_since\_modification\_greater\_than : (Optional) Age in days after last modification to delete the blob. Must be between `0` and `99999`. Defaults to `-1`.  
					delete\_after\_days\_since\_last\_access\_time\_greater\_than : (Optional) Age in days after last access time to delete the blob. Must be between `0` and `99999`. Defaults to `-1`.  
					delete\_after\_days\_since\_creation\_greater\_than : (Optional) Age in days after creation to delete the blob. Must be between `0` and `99999`. Defaults to `-1`.  
					auto\_tier\_to\_hot\_from\_cool\_enabled : (Optional) Whether a blob should automatically be tiered from cool back to hot if accessed again after being tiered to cool. Defaults to `false`.  
        snapshot : (Optional) A `snapshot` block as defined below.  
					change\_tier\_to\_cool\_after\_days\_since\_creation : (Optional) Age in days after creation to tier blob snapshot to cool storage. Must be between `0` and `99999`. Defaults to `-1`.  
					change\_tier\_to\_archive\_after\_days\_since\_creation : (Optional) Age in days after creation to tier blob snapshot to archive storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_archive\_after\_days\_since\_last\_tier\_change\_greater\_than : (Optional) Age in days after last tier change to archive snapshots. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_cold\_after\_days\_since\_creation\_greater\_than : (Optional) Age in days after creation to cold storage. Must be between `0` and `99999`. Defaults to `-1`.  
					delete\_after\_days\_since\_creation\_greater\_than : (Optional) Age in days after creation to delete the blob snapshot. Must be between `0` and `99999`. Defaults to `-1`.  
        version : (Optional) A `version` block as defined below.  
					change\_tier\_to\_cool\_after\_days\_since\_creation : (Optional) Age in days after creation to tier blob version to cool storage. Must be between `0` and `99999`. Defaults to `-1`.  
					change\_tier\_to\_archive\_after\_days\_since\_creation : (Optional) Age in days after creation to tier blob version to archive storage. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_archive\_after\_days\_since\_last\_tier\_change\_greater\_than : (Optional) Age in days after last tier change to archive versions. Must be between `0` and `99999`. Defaults to `-1`.  
					tier\_to\_cold\_after\_days\_since\_creation\_greater\_than : (Optional) Age in days after creation to cold storage. Must be between `0` and `99999`. Defaults to `-1`.  
					delete\_after\_days\_since\_creation : (Optional) Age in days after creation to delete the blob version. Must be between `0` and `99999`. Defaults to `-1`.

Type:

```hcl
object({
    enabled = optional(bool, false)
    rules = optional(list(object({
      name    = string
      enabled = bool
      filters = object({
        blob_types   = list(string)
        prefix_match = optional(list(string))
        match_blob_index_tag = optional(list(object({
          name      = string
          operation = optional(string)
          value     = string
        })), [])
      })
      actions = object({
        base_blob = optional(object({
          tier_to_cool_after_days_since_modification_greater_than        = optional(number)
          tier_to_cool_after_days_since_last_access_time_greater_than    = optional(number)
          tier_to_cool_after_days_since_creation_greater_than            = optional(number)
          tier_to_archive_after_days_since_modification_greater_than     = optional(number)
          tier_to_archive_after_days_since_last_access_time_greater_than = optional(number)
          tier_to_archive_after_days_since_creation_greater_than         = optional(number)
          tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number)
          tier_to_cold_after_days_since_modification_greater_than        = optional(number)
          tier_to_cold_after_days_since_last_access_time_greater_than    = optional(number)
          tier_to_cold_after_days_since_creation_greater_than            = optional(number)
          delete_after_days_since_modification_greater_than              = optional(number)
          delete_after_days_since_last_access_time_greater_than          = optional(number)
          delete_after_days_since_creation_greater_than                  = optional(number)
          auto_tier_to_hot_from_cool_enabled                             = optional(bool)
        }))
        snapshot = optional(object({
          change_tier_to_cool_after_days_since_creation                  = optional(number)
          change_tier_to_archive_after_days_since_creation               = optional(number)
          tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number)
          tier_to_cold_after_days_since_creation_greater_than            = optional(number)
          delete_after_days_since_creation_greater_than                  = optional(number)
        }))
        version = optional(object({
          change_tier_to_cool_after_days_since_creation                  = optional(number)
          change_tier_to_archive_after_days_since_creation               = optional(number)
          tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number)
          tier_to_cold_after_days_since_creation_greater_than            = optional(number)
          delete_after_days_since_creation                               = optional(number)
        }))
      })
    })), [])
  })
```

Default:

```json
{
  "enabled": false,
  "rules": []
}
```

### <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version)

Description: (Optional) The minimum supported TLS version for the storage account. Possible values are `TLS1_0`, `TLS1_1`, `TLS1_2` and `TLS1_3`. Defaults to `TLS1_2`.

Type: `string`

Default: `"TLS1_2"`

### <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules)

Description:   (Optional) A `network_rules` block as documented below.  
    default\_action : (Required) Specifies the default action of allow or deny when no other rules match. Valid options are `Deny` or `Allow`.  
    bypass : (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`.  
    ip\_rules : (Optional) List of public IP or IP ranges in CIDR format. Only IPv4 addresses are allowed.  
    virtual\_network\_subnet\_ids : (Optional) A list of resource ids for subnets.  
    private\_link\_access : (Optional) One or more `private_link_access` blocks as defined below.  
	    endpoint\_resource\_id : (Required) The ID of the Azure resource that should be allowed access to the target storage account.  
	    endpoint\_tenant\_id : (Optional) The tenant id of the resource of the resource access rule to be granted access. Defaults to the current tenant id.

Type:

```hcl
object({
    default_action             = optional(string)
    bypass                     = optional(list(string), [])
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
    private_link_access = optional(list(object({
      endpoint_resource_id = string
      endpoint_tenant_id   = optional(string)
    })), [])
  })
```

Default: `null`

### <a name="input_nfsv3_enabled"></a> [nfsv3\_enabled](#input\_nfsv3\_enabled)

Description: (Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to `false`.

Type: `bool`

Default: `false`

### <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint)

Description:   (Optional) Private endpoint configuration. If provided, a private endpoint is created.  
    name : (Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created.  
    resource\_group\_name : (Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created.  
    location : (Required) The supported Azure location where the resource exists. Changing this forces a new resource to be created.  
    subnet\_id : (Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created.  
    custom\_network\_interface\_name : (Optional) The custom name of the network interface attached to the private endpoint. Changing this forces a new resource to be created.  
    tags : (Optional) A mapping of tags to assign to the resource.  
    private\_service\_connection : (Required) A `private_service_connection` block as defined below.  
      name : (Required) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created.  
      is\_manual\_connection : (Required) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created.  
      private\_connection\_resource\_id : (Optional) The ID of the Private Link Enabled Remote Resource to connect to. One of this or `private_connection_resource_alias` must be specified.  
      private\_connection\_resource\_alias : (Optional) The Service Alias of the Private Link Enabled Remote Resource to connect to. One of this or `private_connection_resource_id` must be specified.  
      subresource\_names : (Optional) A list of subresource names which the Private Endpoint is able to connect to.  
      request\_message : (Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection. Only valid if `is_manual_connection` is `true`.  
    private\_dns\_zone\_group : (Optional) One or more `private_dns_zone_group` blocks as defined below.  
      name : (Required) Specifies the Name of the Private DNS Zone Group.  
      private\_dns\_zone\_ids : (Required) Specifies the list of Private DNS Zones to include within the `private_dns_zone_group`.  
    ip\_configuration : (Optional) One or more `ip_configuration` blocks as defined below.  
      name : (Required) Specifies the Name of the IP Configuration. Changing this forces a new resource to be created.  
      private\_ip\_address : (Required) Specifies the static IP address within the private endpoint's subnet to be used. Changing this forces a new resource to be created.  
      subresource\_name : (Optional) Specifies the subresource this IP address applies to.  
      member\_name : (Optional) Specifies the member name this IP address applies to. If it is not specified, it will use the value of `subresource_name`.

Type:

```hcl
object({
    name                          = string
    location                      = string
    resource_group_name           = string
    subnet_id                     = string
    custom_network_interface_name = optional(string)
    tags                          = optional(map(string))
    private_service_connection = object({
      name                              = string
      is_manual_connection              = bool
      private_connection_resource_id    = optional(string)
      private_connection_resource_alias = optional(string)
      subresource_names                 = optional(list(string))
      request_message                   = optional(string)
    })
    private_dns_zone_group = optional(list(object({
      name                 = string
      private_dns_zone_ids = list(string)
    })), [])
    ip_configuration = optional(list(object({
      name               = string
      private_ip_address = string
      subresource_name   = optional(string)
      member_name        = optional(string)
    })), [])
  })
```

Default: `null`

### <a name="input_provisioned_billing_model_version"></a> [provisioned\_billing\_model\_version](#input\_provisioned\_billing\_model\_version)

Description: (Optional) Specifies the version of the provisioned billing model (e.g. when account\_kind = "FileStorage" for Storage File). Possible value is `V2`. Changing this forces a new resource to be created.

Type: `string`

Default: `null`

### <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled)

Description: (Optional) Whether the public network access is enabled? Defaults to `true`.

Type: `bool`

Default: `true`

### <a name="input_queue_encryption_key_type"></a> [queue\_encryption\_key\_type](#input\_queue\_encryption\_key\_type)

Description: (Optional) The encryption type of the queue service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`.

Type: `string`

Default: `"Service"`

### <a name="input_queue_properties"></a> [queue\_properties](#input\_queue\_properties)

Description:   (Optional) A `queue_properties` block as defined below.  
    cors\_rule : (Optional) A list of `cors_rule` blocks as defined below.  
      allowed\_headers : (Required) A list of headers that are allowed to be a part of the cross-origin request.  
      allowed\_methods : (Required) A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.  
      allowed\_origins : (Required) A list of origin domains that will be allowed by CORS.  
      exposed\_headers : (Required) A list of response headers that are exposed to CORS clients.  
      max\_age\_in\_seconds : (Required) The number of seconds the client should cache a preflight response.  
    logging : (Optional) A `logging` block as defined below.  
      delete : (Required) Indicates whether all delete requests should be logged.  
      read : (Required) Indicates whether all read requests should be logged.  
      write : (Required) Indicates whether all write requests should be logged.  
      version : (Required) The version of storage analytics to configure.  
      retention\_policy\_days : (Optional) Specifies the number of days that logs will be retained.  
    minute\_metrics : (Optional) A `minute_metrics` block as defined below.  
      enabled : (Required) Indicates whether minute metrics are enabled for the Queue service.  
      version : (Required) The version of storage analytics to configure.  
      include\_apis : (Optional) Indicates whether metrics should generate summary statistics for called API operations.  
      retention\_policy\_days : (Optional) Specifies the number of days that logs will be retained.  
    hour\_metrics : (Optional) A `hour_metrics` block as defined below.  
      enabled : (Required) Indicates whether hour metrics are enabled for the Queue service.  
      version : (Required) The version of storage analytics to configure.  
      include\_apis : (Optional) Indicates whether metrics should generate summary statistics for called API operations.  
      retention\_policy\_days : (Optional) Specifies the number of days that logs will be retained.

Type:

```hcl
object({
    cors_rule = optional(list(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })), [])
    logging = optional(object({
      delete                = bool
      read                  = bool
      write                 = bool
      version               = string
      retention_policy_days = number
    }))
    minute_metrics = optional(object({
      enabled               = bool
      include_apis          = bool
      version               = string
      retention_policy_days = number
    }))
    hour_metrics = optional(object({
      enabled               = bool
      include_apis          = bool
      version               = string
      retention_policy_days = number
    }))
  })
```

Default: `null`

### <a name="input_routing"></a> [routing](#input\_routing)

Description:   (Optional) A `routing` block as defined below.  
    publish\_internet\_endpoints : (Optional) Should internet routing storage endpoints be published? Defaults to `false`.  
    publish\_microsoft\_endpoints : (Optional) Should Microsoft routing storage endpoints be published? Defaults to `false`.  
    choice : (Optional) Specifies the kind of network routing opted by the user. Possible values are `InternetRouting` and `MicrosoftRouting`. Defaults to `MicrosoftRouting`.

Type:

```hcl
object({
    publish_internet_endpoints  = optional(bool)
    publish_microsoft_endpoints = optional(bool)
    choice                      = optional(string)
  })
```

Default: `null`

### <a name="input_sas_policy"></a> [sas\_policy](#input\_sas\_policy)

Description:   (Optional) A `sas_policy` block as defined below.  
  expiration\_period : (Required) The SAS expiration period in format of `DD.HH:MM:SS`.  
  expiration\_action : (Optional) The SAS expiration action. Possible values are `Log` and `Block`. Defaults to `Log`.

Type:

```hcl
object({
    expiration_period = optional(string)
    expiration_action = optional(string)
  })
```

Default: `null`

### <a name="input_sftp_enabled"></a> [sftp\_enabled](#input\_sftp\_enabled)

Description: (Optional) Boolean, enable SFTP for the storage account.

Type: `bool`

Default: `false`

### <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled)

Description: (Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). Defaults to `false`.

Type: `bool`

Default: `false`

### <a name="input_static_website"></a> [static\_website](#input\_static\_website)

Description:   (Optional) A `static_website` block as defined below.  
  index\_document : (Optional) The webpage that Azure Storage serves for requests to the root of a website or any subfolder. The value is case-sensitive.  
  error\_404\_document : (Optional) The absolute path to a custom webpage that should be used when a request is made which does not correspond to an existing file.

Type:

```hcl
object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
```

Default: `null`

### <a name="input_storage_account_customer_managed_key"></a> [storage\_account\_customer\_managed\_key](#input\_storage\_account\_customer\_managed\_key)

Description:   (Optional) Customer managed key settings for azurerm\_storage\_account\_customer\_managed\_key.  
    key\_vault\_key\_id : (Required) The ID of the Key Vault Key.  
    user\_assigned\_identity\_id : (Optional) The ID of a user assigned identity.  
    federated\_identity\_client\_id : (Optional) The Client ID of the multi-tenant application to be used in conjunction with the user-assigned identity for cross-tenant customer-managed-keys server-side encryption on the storage account.

Type:

```hcl
object({
    key_vault_key_id             = string
    user_assigned_identity_id    = optional(string)
    federated_identity_client_id = optional(string)
  })
```

Default: `null`

### <a name="input_storage_blobs"></a> [storage\_blobs](#input\_storage\_blobs)

Description:   (Optional) Storage blobs to create.  
    name : (Required) The name of the storage blob. Must be unique within the storage container the blob is located. Changing this forces a new resource to be created.  
	container\_name : (Optional) The name of the storage container in which this blob should be created. Defaults to `name` when omitted. Changing this forces a new resource to be created.  
	type : (Optional) The type of the storage blob to be created. Possible values are `Append`, `Block` or `Page`. Defaults to `Block`. Changing this forces a new resource to be created.  
    size : (Optional) Used only for `Page` blobs to specify the size in bytes of the blob to be created. Must be a multiple of 512. Defaults to `0`. Changing this forces a new resource to be created.  
    access\_tier : (Optional) The access tier of the storage blob. Possible values are `Archive`, `Cool` and `Hot`.  
    cache\_control : (Optional) Controls the cache control header content of the response when blob is requested.  
    content\_type : (Optional) The content type of the storage blob. Cannot be defined if `source_uri` is defined. Defaults to `application/octet-stream`.  
    content\_md5 : (Optional) The MD5 sum of the blob contents. Cannot be defined if `source_uri` is defined, or if blob type is Append or Page. Changing this forces a new resource to be created.  
    encryption\_scope : (Optional) The encryption scope to use for this blob. Changing this forces a new resource to be created.  
    source : (Optional) An absolute path to a file on the local system. This field cannot be specified for Append blobs and cannot be specified if `source_content` or `source_uri` is specified. Changing this forces a new resource to be created.  
    source\_content : (Optional) The content for this blob which should be defined inline. This field can only be specified for Block blobs and cannot be specified if `source` or `source_uri` is specified. Changing this forces a new resource to be created.  
    source\_uri : (Optional) The URI of an existing blob, or a file in the Azure File service, to use as the source contents for the blob to be created. Changing this forces a new resource to be created.  
    parallelism : (Optional) The number of workers per CPU core to run for concurrent uploads. Defaults to `8`. Changing this forces a new resource to be created.  
    metadata : (Optional) A map of custom blob metadata.

Type:

```hcl
list(object({
    name             = string
    container_name   = optional(string)
    type             = optional(string, "Block")
    size             = optional(number)
    access_tier      = optional(string)
    cache_control    = optional(string)
    content_type     = optional(string)
    content_md5      = optional(string)
    encryption_scope = optional(string)
    source           = optional(string)
    source_content   = optional(string)
    source_uri       = optional(string)
    parallelism      = optional(number)
    metadata         = optional(map(string))
  }))
```

Default: `[]`

### <a name="input_storage_containers"></a> [storage\_containers](#input\_storage\_containers)

Description:   (Optional) Storage containers to create.  
    name : (Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created.  
    container\_access\_type : (Optional) The Access Level configured for this Container. Possible values are `blob`, `container` or `private`. Defaults to `private`.  
    default\_encryption\_scope : (Optional) The default encryption scope to use for blobs uploaded to this container. Changing this forces a new resource to be created.  
    encryption\_scope\_override\_enabled : (Optional) Whether to allow blobs to override the default encryption scope for this container. Can only be set when specifying `default_encryption_scope`. Defaults to `true`. Changing this forces a new resource to be created.  
    metadata : (Optional) A mapping of MetaData for this Container. All metadata keys should be lowercase.

Type:

```hcl
list(object({
    name                              = string
    container_access_type             = optional(string, "private")
    default_encryption_scope          = optional(string)
    encryption_scope_override_enabled = optional(bool)
    metadata                          = optional(map(string))
  }))
```

Default: `[]`

### <a name="input_storage_queues"></a> [storage\_queues](#input\_storage\_queues)

Description:   (Optional) Storage queues to create.  
    name : (Required) The name of the Queue which should be created within the Storage Account. Must be unique within the storage account the queue is located. Changing this forces a new resource to be created.  
    metadata : (Optional) A mapping of MetaData which should be assigned to this Storage Queue.

Type:

```hcl
list(object({
    name     = string
    metadata = optional(map(string))
  }))
```

Default: `[]`

### <a name="input_storage_tables"></a> [storage\_tables](#input\_storage\_tables)

Description:   (Optional) Storage tables to create.  
    name : (Required) The name of the storage table. Only Alphanumeric characters allowed, starting with a letter. Must be unique within the storage account the table is located. Changing this forces a new resource to be created.  
    acl : (Optional) One or more `acl` blocks as defined below.  
      id : (Required) The ID which should be used for this Shared Identifier.  
      access\_policy : (Optional) An `access_policy` block as defined below.  
        start : (Required) The ISO8061 UTC time at which this Access Policy should be valid from.  
        expiry : (Required) The ISO8061 UTC time at which this Access Policy should be valid until.  
        permissions : (Required) The permissions which should associated with this Shared Identifier.

Type:

```hcl
list(object({
    name = string
    acl = optional(list(object({
      id = string
      access_policy = optional(object({
        start       = string
        expiry      = string
        permissions = string
      }))
    })), [])
  }))
```

Default: `[]`

### <a name="input_table_encryption_key_type"></a> [table\_encryption\_key\_type](#input\_table\_encryption\_key\_type)

Description: (Optional) The encryption type of the table service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`.

Type: `string`

Default: `"Service"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) A mapping of tags to assign to the resource.

Type: `map(string)`

Default: `{}`

## Resources

The following resources are used by this module:

- [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_account_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) (resource)
- [azurerm_storage_account_local_user.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_local_user) (resource)
- [azurerm_storage_account_network_rules.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) (resource)
- [azurerm_storage_blob.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) (resource)
- [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) (resource)
- [azurerm_storage_encryption_scope.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_encryption_scope) (resource)
- [azurerm_storage_management_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) (resource)
- [azurerm_storage_queue.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue) (resource)
- [azurerm_storage_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) (resource)

## Outputs

The following outputs are exported:

### <a name="output_private_endpoint_id"></a> [private\_endpoint\_id](#output\_private\_endpoint\_id)

Description: The private endpoint ID if created.

### <a name="output_storage_account_customer_managed_key_id"></a> [storage\_account\_customer\_managed\_key\_id](#output\_storage\_account\_customer\_managed\_key\_id)

Description: The customer managed key resource ID if created.

### <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id)

Description: The storage account resource ID.

### <a name="output_storage_account_local_user_ids"></a> [storage\_account\_local\_user\_ids](#output\_storage\_account\_local\_user\_ids)

Description: Map of local user IDs keyed by local user name.

### <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name)

Description: The storage account name.

### <a name="output_storage_account_network_rules_id"></a> [storage\_account\_network\_rules\_id](#output\_storage\_account\_network\_rules\_id)

Description: The storage account network rules resource ID if created.

### <a name="output_storage_account_primary_blob_endpoint"></a> [storage\_account\_primary\_blob\_endpoint](#output\_storage\_account\_primary\_blob\_endpoint)

Description: The primary blob endpoint.

### <a name="output_storage_account_primary_queue_endpoint"></a> [storage\_account\_primary\_queue\_endpoint](#output\_storage\_account\_primary\_queue\_endpoint)

Description: The primary queue endpoint.

### <a name="output_storage_account_primary_table_endpoint"></a> [storage\_account\_primary\_table\_endpoint](#output\_storage\_account\_primary\_table\_endpoint)

Description: The primary table endpoint.

### <a name="output_storage_account_primary_web_endpoint"></a> [storage\_account\_primary\_web\_endpoint](#output\_storage\_account\_primary\_web\_endpoint)

Description: The primary web endpoint.

### <a name="output_storage_blob_ids"></a> [storage\_blob\_ids](#output\_storage\_blob\_ids)

Description: Map of storage blob IDs keyed by <container>/<name>.

### <a name="output_storage_container_ids"></a> [storage\_container\_ids](#output\_storage\_container\_ids)

Description: Map of storage container IDs keyed by container name.

### <a name="output_storage_encryption_scope_ids"></a> [storage\_encryption\_scope\_ids](#output\_storage\_encryption\_scope\_ids)

Description: Map of storage encryption scope IDs keyed by scope name.

### <a name="output_storage_management_policy_id"></a> [storage\_management\_policy\_id](#output\_storage\_management\_policy\_id)

Description: The storage management policy ID if created.

### <a name="output_storage_queue_ids"></a> [storage\_queue\_ids](#output\_storage\_queue\_ids)

Description: Map of storage queue IDs keyed by queue name.

### <a name="output_storage_table_ids"></a> [storage\_table\_ids](#output\_storage\_table\_ids)

Description: Map of storage table IDs keyed by table name.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->