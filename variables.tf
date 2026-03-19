variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "Storage account names must be 3-24 characters, lowercase letters and numbers only, with no hyphens or underscores."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  type        = string
}

variable "account_kind" {
  description = "(Optional) Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`."
  type        = string
  default     = "StorageV2"

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "`account_kind` must be one of: \"BlobStorage\", \"BlockBlobStorage\", \"FileStorage\", \"Storage\", \"StorageV2\"."
  }
}

variable "account_tier" {
  description = "(Optional) Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`. For BlockBlobStorage and FileStorage accounts only `Premium` is valid. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "`account_tier` must be one of: \"Standard\", \"Premium\"."
  }
}

variable "account_replication_type" {
  description = "(Optional)  Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`. Changing this forces a new resource to be created when types `LRS`, `GRS` and `RAGRS` are changed to `ZRS`, `GZRS` or `RAGZRS` and vice versa."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "`account_replication_type` must be one of: \"LRS\", \"GRS\", \"RAGRS\", \"ZRS\", \"GZRS\", \"RAGZRS\"."
  }
}

variable "provisioned_billing_model_version" {
  description = "(Optional) Specifies the version of the provisioned billing model (e.g. when account_kind = \"FileStorage\" for Storage File). Possible value is `V2`. Changing this forces a new resource to be created."
  type        = string
  default     = null

  validation {
    condition     = var.provisioned_billing_model_version == null ? true : contains(["V2"], var.provisioned_billing_model_version)
    error_message = "`provisioned_billing_model_version` must be null or \"V2\"."
  }
}

variable "cross_tenant_replication_enabled" {
  description = "(Optional) Should cross Tenant replication be enabled? Defaults to `false`."
  type        = bool
  default     = false
}

variable "access_tier" {
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are `Hot`, `Cool`, `Cold` and `Premium`. Defaults to `Hot`."
  type        = string
  default     = "Hot"

  validation {
    condition     = contains(["Hot", "Cool", "Cold", "Premium"], var.access_tier)
    error_message = "`access_tier` must be one of: \"Hot\", \"Cool\", \"Cold\", \"Premium\"."
  }
}

variable "edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created."
  type        = string
  default     = null
}

variable "https_traffic_only_enabled" {
  description = "(Optional) Boolean flag which forces HTTPS if enabled. Defaults to `true`."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "(Optional) The minimum supported TLS version for the storage account. Possible values are `TLS1_0`, `TLS1_1`, `TLS1_2` and `TLS1_3`. Defaults to `TLS1_2`."
  type        = string
  default     = "TLS1_2"

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2", "TLS1_3"], var.min_tls_version)
    error_message = "`min_tls_version` must be one of: \"TLS1_0\", \"TLS1_1\", \"TLS1_2\", \"TLS1_3\"."
  }
}

variable "allow_nested_items_to_be_public" {
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to `false`."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "(Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). Defaults to `false`."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether the public network access is enabled? Defaults to `true`."
  type        = bool
  default     = true
}

variable "default_to_oauth_authentication" {
  description = "(Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. Defaults to `false`."
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2. Changing this forces a new resource to be created. Defaults to `false`."
  type        = bool
  default     = false

  validation {
    condition = var.is_hns_enabled ? (
      var.account_tier == "Standard" ||
      (var.account_tier == "Premium" && var.account_kind == "BlockBlobStorage")
    ) : true
    error_message = "`is_hns_enabled` can only be true when `account_tier` is Standard, or when `account_tier` is Premium and `account_kind` is BlockBlobStorage."
  }
}

variable "nfsv3_enabled" {
  description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to `false`."
  type        = bool
  default     = false

  validation {
    condition = var.nfsv3_enabled ? (
      var.is_hns_enabled &&
      (
        (var.account_tier == "Standard" && var.account_kind == "StorageV2") ||
        (var.account_tier == "Premium" && var.account_kind == "BlockBlobStorage")
      ) &&
      contains(["LRS", "RAGRS"], var.account_replication_type)
    ) : true
    error_message = "`nfsv3_enabled` requires `is_hns_enabled` to be true, `account_replication_type` to be LRS or RAGRS, and `account_tier`/`account_kind` to be Standard/StorageV2 or Premium/BlockBlobStorage."
  }
}

variable "custom_domain" {
  description = <<EOF
  (Optional) A `custom_domain` block as documented below.
    name : (Required) The Custom Domain Name to use for the Storage Account, which will be validated by Azure.
    use_subdomain : (Optional) Should the Custom Domain Name be validated by using indirect CNAME validation?
  EOF
  type = object({
    name          = string
    use_subdomain = optional(bool)
  })
  default = null

  validation {
    condition = var.custom_domain == null ? true : (
      length(trimspace(var.custom_domain.name)) > 0
    )
    error_message = "custom_domain.name must be a non-empty string when custom_domain is set."
  }
}

variable "customer_managed_key" {
  description = <<EOF
  (Optional) A `customer_managed_key` block as documented below.
    key_vault_id :  (Optional) The ID of the Key Vault Key, supplying a version-less key ID will enable auto-rotation of this key.
    user_assigned_identity_id : (Required) The ID of a user assigned identity.
  EOF
  type = object({
    key_vault_id              = optional(string)
    user_assigned_identity_id = optional(string)
  })
  default = null

  validation {
    condition = var.customer_managed_key == null ? true : (
      var.customer_managed_key.key_vault_id != null &&
      var.customer_managed_key.user_assigned_identity_id != null &&
      can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.KeyVault/vaults/[^/]+/keys/[^/]+(/[^/]+)?$", var.customer_managed_key.key_vault_id)) &&
      can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.ManagedIdentity/userAssignedIdentities/[^/]+$", var.customer_managed_key.user_assigned_identity_id))
    )
    error_message = "customer_managed_key requires key_vault_id and user_assigned_identity_id, and both must be valid Azure resource IDs."
  }
}

variable "identity" {
  description = <<EOF
  (Optional) A `identity` block as documented below.
    type : (Required) Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, or `SystemAssigned, UserAssigned`.
    identity_ids : (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account.
  EOF
  type = object({
    type         = optional(string)
    identity_ids = optional(list(string), [])
  })
  default = null

  validation {
    condition = var.identity == null ? true : (
      var.identity.type != null &&
      contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned", "UserAssigned, SystemAssigned"], var.identity.type) &&
      (!can(regex("UserAssigned", var.identity.type)) || length(var.identity.identity_ids) > 0) &&
      alltrue([
        for identity_id in var.identity.identity_ids : can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.ManagedIdentity/userAssignedIdentities/[^/]+$", identity_id))
      ])
    )
    error_message = "identity.type must be set to SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned. When UserAssigned is used, identity_ids must be provided and valid."
  }
}

variable "blob_properties" {
  description = <<EOF
  (Optional) A `blob_properties` block as defined below.
    cors_rule : (Optional) A `cors_rule` block as defined below.
      allowed_headers : (Required) A list of headers that are allowed to be a part of the cross-origin request.
      allowed_methods : (Required) A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
      allowed_origins : (Required) A list of origin domains that will be allowed by CORS.
      exposed_headers : (Required) A list of response headers that are exposed to CORS clients.
      max_age_in_seconds : (Required) The number of seconds the client should cache a preflight response.
    delete_retention_policy : (Optional) A `delete_retention_policy` block as defined below.
      days : (Optional) Specifies the number of days that the blob should be retained, between 1 and 365 days.
      permanent_delete_enabled : (Optional) Indicates whether permanent deletion of the soft deleted blob versions and snapshots is allowed.
    restore_policy : (Optional) A `restore_policy` block as defined below.
      days : (Required) Specifies the number of days that the blob can be restored, between 1 and 365 days. This must be less than the days specified for delete_retention_policy.
	  versioning_enabled : (Optional) Is versioning enabled?
	  change_feed_enabled : (Optional) Is the blob service properties for change feed events enabled?
	  change_feed_retention_in_days : (Optional) The duration of change feed events retention in days. Possible values are between `1` and `146000` days.
    default_service_version : (Optional) The API Version which should be used by default for requests to the Data Plane API if an incoming request doesn't specify an API Version.
	  last_access_time_enabled : (Optional) Is the last access time based tracking enabled?
	  container_delete_retention_policy : (Optional) A `container_delete_retention_policy` block as defined below.
  EOF
  type = object({
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
  default = null

  validation {
    condition = var.blob_properties == null ? true : (
      (try(var.blob_properties.delete_retention_policy, null) == null || (
        var.blob_properties.delete_retention_policy.days >= 1 &&
        var.blob_properties.delete_retention_policy.days <= 365
      )) &&
      (try(var.blob_properties.container_delete_retention_policy, null) == null || (
        var.blob_properties.container_delete_retention_policy.days >= 1 &&
        var.blob_properties.container_delete_retention_policy.days <= 365
      )) &&
      (try(var.blob_properties.change_feed_retention_in_days, null) == null || (
        var.blob_properties.change_feed_retention_in_days >= 1 &&
        var.blob_properties.change_feed_retention_in_days <= 146000
      )) &&
      (try(var.blob_properties.restore_policy, null) == null || (
        var.blob_properties.restore_policy.days >= 1 &&
        var.blob_properties.restore_policy.days <= 365 &&
        try(var.blob_properties.delete_retention_policy.days, 0) > var.blob_properties.restore_policy.days
      )) &&
      alltrue([
        for rule in try(var.blob_properties.cors_rule, []) : alltrue([
          for method in rule.allowed_methods : contains(["DELETE", "GET", "HEAD", "MERGE", "POST", "OPTIONS", "PUT", "PATCH"], method)
        ])
      ])
    )
    error_message = "blob_properties has invalid retention days or CORS methods. Check delete_retention_policy, container_delete_retention_policy, restore_policy, change_feed_retention_in_days, and cors_rule.allowed_methods."
  }
}

variable "queue_properties" {
  description = <<EOF
  (Optional) A `queue_properties` block as defined below.
    cors_rule : (Optional) A list of `cors_rule` blocks as defined below.
      allowed_headers : (Required) A list of headers that are allowed to be a part of the cross-origin request.
      allowed_methods : (Required) A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
      allowed_origins : (Required) A list of origin domains that will be allowed by CORS.
      exposed_headers : (Required) A list of response headers that are exposed to CORS clients.
      max_age_in_seconds : (Required) The number of seconds the client should cache a preflight response.
    logging : (Optional) A `logging` block as defined below.
      delete : (Required) Indicates whether all delete requests should be logged.
      read : (Required) Indicates whether all read requests should be logged.
      write : (Required) Indicates whether all write requests should be logged.
      version : (Required) The version of storage analytics to configure.
      retention_policy_days : (Optional) Specifies the number of days that logs will be retained.
    minute_metrics : (Optional) A `minute_metrics` block as defined below.
      enabled : (Required) Indicates whether minute metrics are enabled for the Queue service.
      version : (Required) The version of storage analytics to configure.
      include_apis : (Optional) Indicates whether metrics should generate summary statistics for called API operations.
      retention_policy_days : (Optional) Specifies the number of days that logs will be retained.
    hour_metrics : (Optional) A `hour_metrics` block as defined below.
      enabled : (Required) Indicates whether hour metrics are enabled for the Queue service.
      version : (Required) The version of storage analytics to configure.
      include_apis : (Optional) Indicates whether metrics should generate summary statistics for called API operations.
      retention_policy_days : (Optional) Specifies the number of days that logs will be retained.
  EOF
  type = object({
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
  default = null

  validation {
    condition = var.queue_properties == null ? true : (
      alltrue([
        for rule in var.queue_properties.cors_rule : alltrue([
          for method in rule.allowed_methods : contains(["DELETE", "GET", "HEAD", "MERGE", "POST", "OPTIONS", "PUT", "PATCH"], method)
        ])
      ]) &&
      (try(var.queue_properties.logging, null) == null || var.queue_properties.logging.version != "") &&
      (try(var.queue_properties.minute_metrics, null) == null || var.queue_properties.minute_metrics.version != "") &&
      (try(var.queue_properties.hour_metrics, null) == null || var.queue_properties.hour_metrics.version != "")
    )
    error_message = "queue_properties has invalid CORS methods or missing metric/logging versions."
  }
}

variable "static_website" {
  description = <<EOF
  (Optional) A `static_website` block as defined below.
  index_document : (Optional) The webpage that Azure Storage serves for requests to the root of a website or any subfolder. The value is case-sensitive.
  error_404_document : (Optional) The absolute path to a custom webpage that should be used when a request is made which does not correspond to an existing file.
  EOF
  type = object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
  default = null

  validation {
    condition = var.static_website == null ? true : (
      (var.static_website.index_document == null || length(trimspace(var.static_website.index_document)) > 0) &&
      (var.static_website.error_404_document == null || length(trimspace(var.static_website.error_404_document)) > 0)
    )
    error_message = "static_website index_document and error_404_document must be non-empty when set."
  }
}

variable "large_file_share_enabled" {
  description = "(Optional) Are Large File Shares Enabled?"
  type        = bool
  default     = false
}

variable "local_user_enabled" {
  description = "(Optional) Is Local User Enabled?"
  type        = bool
  default     = false
}

variable "routing" {
  description = <<EOF
  (Optional) A `routing` block as defined below.
    publish_internet_endpoints : (Optional) Should internet routing storage endpoints be published? Defaults to `false`.
    publish_microsoft_endpoints : (Optional) Should Microsoft routing storage endpoints be published? Defaults to `false`.
    choice : (Optional) Specifies the kind of network routing opted by the user. Possible values are `InternetRouting` and `MicrosoftRouting`. Defaults to `MicrosoftRouting`.
  EOF
  type = object({
    publish_internet_endpoints  = optional(bool)
    publish_microsoft_endpoints = optional(bool)
    choice                      = optional(string)
  })
  default = null

  validation {
    condition = var.routing == null ? true : (
      var.routing.choice == null || contains(["InternetRouting", "MicrosoftRouting"], var.routing.choice)
    )
    error_message = "routing.choice must be InternetRouting or MicrosoftRouting."
  }
}

variable "queue_encryption_key_type" {
  description = "(Optional) The encryption type of the queue service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`."
  type        = string
  default     = "Service"

  validation {
    condition = (
      contains(["Service", "Account"], var.queue_encryption_key_type) &&
      (var.queue_encryption_key_type != "Account" || var.account_kind != "Storage")
    )
    error_message = "queue_encryption_key_type must be Service or Account, and cannot be Account when account_kind is Storage."
  }
}

variable "table_encryption_key_type" {
  description = "(Optional) The encryption type of the table service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`."
  type        = string
  default     = "Service"

  validation {
    condition = (
      contains(["Service", "Account"], var.table_encryption_key_type) &&
      (var.table_encryption_key_type != "Account" || var.account_kind != "Storage")
    )
    error_message = "`table_encryption_key_type` must be `Service` or `Account`, and cannot be `Account` when `account_kind` is `Storage`."
  }
}

variable "infrastructure_encryption_enabled" {
  description = "(Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created."
  type        = bool
  default     = true

  validation {
    condition = var.infrastructure_encryption_enabled ? (
      var.account_kind == "StorageV2" ||
      (var.account_tier == "Premium" && contains(["BlockBlobStorage", "FileStorage"], var.account_kind))
    ) : true
    error_message = "`infrastructure_encryption_enabled` can only be true when `account_kind` is `StorageV2` or when `account_tier` is `Premium` and `account_kind` is `BlockBlobStorage` or `FileStorage`."
  }
}

variable "immutability_policy" {
  description = <<EOF
  (Optional) An `immutability_policy` block as defined below. Changing this forces a new resource to be created.
    allow_protected_append_writes : (Required) When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance.
    period_since_creation_in_days : (Required) The immutability period for the blobs in the container since the policy creation, in days.
    state : (Required) Defines the mode of the policy. Possible values are `Disabled`, `Unlocked`, and `Locked`.
  EOF
  type = object({
    allow_protected_append_writes = optional(bool)
    period_since_creation_in_days = optional(number)
    state                         = optional(string)
  })
  default = null

  validation {
    condition = var.immutability_policy == null ? true : (
      var.immutability_policy.state != null &&
      contains(["Disabled", "Unlocked", "Locked"], var.immutability_policy.state) &&
      var.immutability_policy.period_since_creation_in_days != null &&
      var.immutability_policy.period_since_creation_in_days >= 1 &&
      var.immutability_policy.allow_protected_append_writes != null
    )
    error_message = "immutability_policy requires allow_protected_append_writes, period_since_creation_in_days (>= 1), and state (Disabled, Unlocked, Locked)."
  }
}

variable "sas_policy" {
  description = <<EOF
  (Optional) A `sas_policy` block as defined below.
  expiration_period : (Required) The SAS expiration period in format of `DD.HH:MM:SS`.
  expiration_action : (Optional) The SAS expiration action. Possible values are `Log` and `Block`. Defaults to `Log`.
  EOF
  type = object({
    expiration_period = optional(string)
    expiration_action = optional(string)
  })
  default = null

  validation {
    condition = var.sas_policy == null ? true : (
      var.sas_policy.expiration_period != null &&
      can(regex("^[0-9]+\\.[0-9]{2}:[0-9]{2}:[0-9]{2}$", var.sas_policy.expiration_period)) &&
      (var.sas_policy.expiration_action == null || contains(["Log", "Block"], var.sas_policy.expiration_action))
    )
    error_message = "sas_policy.expiration_period must be in DD.HH:MM:SS format and expiration_action must be Log or Block."
  }
}

variable "allowed_copy_scope" {
  description = "(Optional) Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Possible values are `AAD` and `PrivateLink`."
  type        = string
  default     = null

  validation {
    condition     = var.allowed_copy_scope == null ? true : contains(["AAD", "PrivateLink"], var.allowed_copy_scope)
    error_message = "allowed_copy_scope must be AAD or PrivateLink."
  }
}

variable "sftp_enabled" {
  description = "(Optional) Boolean, enable SFTP for the storage account."
  type        = bool
  default     = false

  validation {
    condition     = var.sftp_enabled ? var.is_hns_enabled : true
    error_message = "`sftp_enabled` requires `is_hns_enabled` to be true."
  }
}

variable "dns_endpoint_type" {
  description = "(Optional) Specifies which DNS endpoint type to use. Possible values are `Standard` and `AzureDnsZone`. Defaults to `Standard`. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "AzureDnsZone"], var.dns_endpoint_type)
    error_message = "`dns_endpoint_type` must be \"Standard\" or \"AzureDnsZone\"."
  }
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "storage_account_customer_managed_key" {
  description = <<EOF
  (Optional) Customer managed key settings for azurerm_storage_account_customer_managed_key.
    key_vault_key_id : (Required) The ID of the Key Vault Key.
    user_assigned_identity_id : (Optional) The ID of a user assigned identity.
    federated_identity_client_id : (Optional) The Client ID of the multi-tenant application to be used in conjunction with the user-assigned identity for cross-tenant customer-managed-keys server-side encryption on the storage account.
  EOF
  type = object({
    key_vault_key_id             = string
    user_assigned_identity_id    = optional(string)
    federated_identity_client_id = optional(string)
  })
  default = null

  validation {
    condition = var.storage_account_customer_managed_key == null ? true : (
      can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.KeyVault/vaults/[^/]+/keys/[^/]+(/[^/]+)?$", var.storage_account_customer_managed_key.key_vault_key_id)) &&
      (var.storage_account_customer_managed_key.user_assigned_identity_id == null || can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.ManagedIdentity/userAssignedIdentities/[^/]+$", var.storage_account_customer_managed_key.user_assigned_identity_id))) &&
      (var.storage_account_customer_managed_key.federated_identity_client_id == null || can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.storage_account_customer_managed_key.federated_identity_client_id)))
    )
    error_message = "storage_account_customer_managed_key requires key_vault_key_id, and any provided IDs must be valid Azure resource IDs."
  }
}

variable "local_users" {
  description = <<EOF
  (Optional) Local users to create on the storage account.
    name : (Required) The name which should be used for this Storage Account Local User.
    home_directory : (Optional) The home directory of the Storage Account Local User.
    permission_scopes : (Optional) One or more `permission_scope` blocks as defined below.
      permissions : (Required) A `permissions` block as defined below.
        create : (Optional) Specifies if the Local User has the create permission for this scope. Defaults to `false`.
        delete : (Optional) Specifies if the Local User has the delete permission for this scope. Defaults to `false`.
        list : (Optional) Specifies if the Local User has the list permission for this scope. Defaults to `false`.
        read : (Optional) Specifies if the Local User has the read permission for this scope. Defaults to `false`.
        write : (Optional) Specifies if the Local User has the write permission for this scope. Defaults to `false`.
      resource_name : (Required) The container name (when `service` is set to `blob`) or the file share name (when `service` is set to `file`), used by the Storage Account Local User.
      service : (Required) The storage service used by this Storage Account Local User. Possible values are `blob` and `file`.
    ssh_authorized_keys : (Optional) One or more `ssh_authorized_key` blocks as defined below.
      key : (Required) The public key value of this SSH authorized key.
      description : (Optional) The description of this SSH authorized key.
    ssh_key_enabled : (Optional) Specifies whether SSH Key Authentication is enabled. Defaults to `false`.
    ssh_password_enabled : (Optional) Specifies whether SSH Password Authentication is enabled. Defaults to `false`.
  EOF
  type = list(object({
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
  default = []

  validation {
    condition = alltrue([
      for user in var.local_users : alltrue([
        for scope in user.permission_scopes : contains(["blob", "file"], scope.service)
      ])
    ])
    error_message = "local_users permission_scopes.service must be \"blob\" or \"file\"."
  }
}

variable "network_rules" {
  description = <<EOF
  (Optional) A `network_rules` block as documented below.
    default_action : (Required) Specifies the default action of allow or deny when no other rules match. Valid options are `Deny` or `Allow`.
    bypass : (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`.
    ip_rules : (Optional) List of public IP or IP ranges in CIDR format. Only IPv4 addresses are allowed.
    virtual_network_subnet_ids : (Optional) A list of resource ids for subnets.
    private_link_access : (Optional) One or more `private_link_access` blocks as defined below.
	    endpoint_resource_id : (Required) The ID of the Azure resource that should be allowed access to the target storage account.
	    endpoint_tenant_id : (Optional) The tenant id of the resource of the resource access rule to be granted access. Defaults to the current tenant id.
  EOF
  type = object({
    default_action             = optional(string)
    bypass                     = optional(list(string), [])
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
    private_link_access = optional(list(object({
      endpoint_resource_id = string
      endpoint_tenant_id   = optional(string)
    })), [])
  })
  default = null

  validation {
    condition = var.network_rules == null ? true : (
      (var.network_rules.default_action == null || contains(["Deny", "Allow"], var.network_rules.default_action)) &&
      alltrue([
        for rule in var.network_rules.bypass : contains(["Logging", "Metrics", "AzureServices", "None"], rule)
      ])
    )
    error_message = "`network_rules.default_action` must be \"Deny\" or \"Allow\", and bypass entries must be \"Logging\", \"Metrics\", \"AzureServices\", or \"None\"."
  }
}

variable "storage_blobs" {
  description = <<EOF
  (Optional) Storage blobs to create.
    name : (Required) The name of the storage blob. Must be unique within the storage container the blob is located. Changing this forces a new resource to be created.
	container_name : (Optional) The name of the storage container in which this blob should be created. Defaults to `name` when omitted. Changing this forces a new resource to be created.
	type : (Optional) The type of the storage blob to be created. Possible values are `Append`, `Block` or `Page`. Defaults to `Block`. Changing this forces a new resource to be created.
    size : (Optional) Used only for `Page` blobs to specify the size in bytes of the blob to be created. Must be a multiple of 512. Defaults to `0`. Changing this forces a new resource to be created.
    access_tier : (Optional) The access tier of the storage blob. Possible values are `Archive`, `Cool` and `Hot`.
    cache_control : (Optional) Controls the cache control header content of the response when blob is requested.
    content_type : (Optional) The content type of the storage blob. Cannot be defined if `source_uri` is defined. Defaults to `application/octet-stream`.
    content_md5 : (Optional) The MD5 sum of the blob contents. Cannot be defined if `source_uri` is defined, or if blob type is Append or Page. Changing this forces a new resource to be created.
    encryption_scope : (Optional) The encryption scope to use for this blob. Changing this forces a new resource to be created.
    source : (Optional) An absolute path to a file on the local system. This field cannot be specified for Append blobs and cannot be specified if `source_content` or `source_uri` is specified. Changing this forces a new resource to be created.
    source_content : (Optional) The content for this blob which should be defined inline. This field can only be specified for Block blobs and cannot be specified if `source` or `source_uri` is specified. Changing this forces a new resource to be created.
    source_uri : (Optional) The URI of an existing blob, or a file in the Azure File service, to use as the source contents for the blob to be created. Changing this forces a new resource to be created.
    parallelism : (Optional) The number of workers per CPU core to run for concurrent uploads. Defaults to `8`. Changing this forces a new resource to be created.
    metadata : (Optional) A map of custom blob metadata.
  EOF
  type = list(object({
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
  default = []

  validation {
    condition = alltrue([
      for blob in var.storage_blobs : (
        (blob.type == null || contains(["Append", "Block", "Page"], blob.type)) &&
        (blob.access_tier == null || contains(["Archive", "Cool", "Hot"], blob.access_tier)) &&
        (blob.size == null || blob.size % 512 == 0) &&
        (
          blob.source == null || (blob.source_content == null && blob.source_uri == null)
        ) &&
        (
          blob.source_content == null || (blob.type == "Block" && blob.source == null && blob.source_uri == null)
        ) &&
        (
          blob.source_uri == null || (blob.source == null && blob.source_content == null)
        ) &&
        (
          blob.content_md5 == null || (blob.type == "Block" && blob.source_uri == null)
        ) &&
        (
          blob.content_type == null || blob.source_uri == null
        )
      )
    ])
    error_message = "`storage_blobs` must use valid type/access_tier values, size must be a multiple of 512, and source/source_content/source_uri are mutually exclusive with doc constraints."
  }
}

variable "storage_containers" {
  description = <<EOF
  (Optional) Storage containers to create.
    name : (Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created.
    container_access_type : (Optional) The Access Level configured for this Container. Possible values are `blob`, `container` or `private`. Defaults to `private`.
    default_encryption_scope : (Optional) The default encryption scope to use for blobs uploaded to this container. Changing this forces a new resource to be created.
    encryption_scope_override_enabled : (Optional) Whether to allow blobs to override the default encryption scope for this container. Can only be set when specifying `default_encryption_scope`. Defaults to `true`. Changing this forces a new resource to be created.
    metadata : (Optional) A mapping of MetaData for this Container. All metadata keys should be lowercase.
  EOF
  type = list(object({
    name                              = string
    container_access_type             = optional(string, "private")
    default_encryption_scope          = optional(string)
    encryption_scope_override_enabled = optional(bool)
    metadata                          = optional(map(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for container in var.storage_containers : (
        container.container_access_type == null || contains(["blob", "container", "private"], container.container_access_type)
      )
    ])
    error_message = "`storage_containers.container_access_type` must be \"blob\", \"container\", or \"private\"."
  }
}

variable "encryption_scopes" {
  description = <<EOF
  (Optional) Storage encryption scopes to create.
    name : (Required) The name which should be used for this Storage Encryption Scope. Changing this forces a new Storage Encryption Scope to be created.
    source : (Required) The source of the Storage Encryption Scope. Possible values are `Microsoft.KeyVault` and `Microsoft.Storage`.
    key_vault_key_id : (Optional) The ID of the Key Vault Key. Required when `source` is `Microsoft.KeyVault`.
    infrastructure_encryption_required : (Optional) Is a secondary layer of encryption with Platform Managed Keys for data applied? Changing this forces a new resource to be created.
  EOF
  type = list(object({
    name                               = string
    source                             = string
    key_vault_key_id                   = optional(string)
    infrastructure_encryption_required = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for scope in var.encryption_scopes : (
        contains(["Microsoft.KeyVault", "Microsoft.Storage"], scope.source) &&
        (scope.source != "Microsoft.KeyVault" || scope.key_vault_key_id != null)
      )
    ])
    error_message = "`encryption_scopes.source` must be \"Microsoft.KeyVault\" or \"Microsoft.Storage\", and key_vault_key_id is required when source is Microsoft.KeyVault."
  }
}

variable "management_policy" {
  description = <<EOF
  (Optional) Storage management policy configuration.
    rules : (Optional) One or more `rule` blocks as defined below.
      name : (Required) The name of the rule. Rule name is case-sensitive. It must be unique within a policy.
      enabled : (Required) Boolean to specify whether the rule is enabled.
      filters : (Required) A `filters` block as defined below.
        blob_types : (Required) Valid options are `blockBlob` and `appendBlob`.
        prefix_match : (Optional) An array of strings for prefixes to be matched.
        match_blob_index_tag : (Optional) A `match_blob_index_tag` block as defined below.
          name : (Required) The filter tag name used for tag based filtering for blob objects.
          operation : (Optional) The comparison operator used for object comparison and filtering. Possible value is `==`.
          value : (Required) The filter tag value used for tag based filtering for blob objects.
      actions : (Required) An `actions` block as defined below.
        base_blob : (Optional) A `base_blob` block as defined below.
					tier_to_cool_after_days_since_modification_greater_than : (Optional) Age in days after last modification to tier blobs to cool storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_cool_after_days_since_last_access_time_greater_than : (Optional) Age in days after last access time to tier blobs to cool storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_cool_after_days_since_creation_greater_than : (Optional) Age in days after creation to cool storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_archive_after_days_since_modification_greater_than : (Optional) Age in days after last modification to tier blobs to archive storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_archive_after_days_since_last_access_time_greater_than : (Optional) Age in days after last access time to tier blobs to archive storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_archive_after_days_since_creation_greater_than : (Optional) Age in days after creation to archive storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_archive_after_days_since_last_tier_change_greater_than : (Optional) Age in days after last tier change to archive blobs. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_cold_after_days_since_modification_greater_than : (Optional) Age in days after last modification to tier blobs to cold storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_cold_after_days_since_last_access_time_greater_than : (Optional) Age in days after last access time to tier blobs to cold storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_cold_after_days_since_creation_greater_than : (Optional) Age in days after creation to cold storage. Must be between `0` and `99999`. Defaults to `-1`.
					delete_after_days_since_modification_greater_than : (Optional) Age in days after last modification to delete the blob. Must be between `0` and `99999`. Defaults to `-1`.
					delete_after_days_since_last_access_time_greater_than : (Optional) Age in days after last access time to delete the blob. Must be between `0` and `99999`. Defaults to `-1`.
					delete_after_days_since_creation_greater_than : (Optional) Age in days after creation to delete the blob. Must be between `0` and `99999`. Defaults to `-1`.
					auto_tier_to_hot_from_cool_enabled : (Optional) Whether a blob should automatically be tiered from cool back to hot if accessed again after being tiered to cool. Defaults to `false`.
        snapshot : (Optional) A `snapshot` block as defined below.
					change_tier_to_cool_after_days_since_creation : (Optional) Age in days after creation to tier blob snapshot to cool storage. Must be between `0` and `99999`. Defaults to `-1`.
					change_tier_to_archive_after_days_since_creation : (Optional) Age in days after creation to tier blob snapshot to archive storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_archive_after_days_since_last_tier_change_greater_than : (Optional) Age in days after last tier change to archive snapshots. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_cold_after_days_since_creation_greater_than : (Optional) Age in days after creation to cold storage. Must be between `0` and `99999`. Defaults to `-1`.
					delete_after_days_since_creation_greater_than : (Optional) Age in days after creation to delete the blob snapshot. Must be between `0` and `99999`. Defaults to `-1`.
        version : (Optional) A `version` block as defined below.
					change_tier_to_cool_after_days_since_creation : (Optional) Age in days after creation to tier blob version to cool storage. Must be between `0` and `99999`. Defaults to `-1`.
					change_tier_to_archive_after_days_since_creation : (Optional) Age in days after creation to tier blob version to archive storage. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_archive_after_days_since_last_tier_change_greater_than : (Optional) Age in days after last tier change to archive versions. Must be between `0` and `99999`. Defaults to `-1`.
					tier_to_cold_after_days_since_creation_greater_than : (Optional) Age in days after creation to cold storage. Must be between `0` and `99999`. Defaults to `-1`.
					delete_after_days_since_creation : (Optional) Age in days after creation to delete the blob version. Must be between `0` and `99999`. Defaults to `-1`.
  EOF
  type = object({
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
  default = {
    enabled = false
    rules   = []
  }

  validation {
    condition = (
      (!try(var.management_policy.enabled, false) || length(try(var.management_policy.rules, [])) > 0) &&
      alltrue([
        for rule in try(var.management_policy.rules, []) : alltrue([
          alltrue([for blob_type in rule.filters.blob_types : contains(["blockBlob", "appendBlob"], blob_type)]),
          alltrue([
            for tag in try(rule.filters.match_blob_index_tag, []) : (tag.operation == null || tag.operation == "==")
          ]),
          try(rule.actions.base_blob, null) == null ? true : (
            alltrue([
              for value in [
                rule.actions.base_blob.tier_to_cool_after_days_since_modification_greater_than,
                rule.actions.base_blob.tier_to_cool_after_days_since_last_access_time_greater_than,
                rule.actions.base_blob.tier_to_cool_after_days_since_creation_greater_than,
                rule.actions.base_blob.tier_to_archive_after_days_since_modification_greater_than,
                rule.actions.base_blob.tier_to_archive_after_days_since_last_access_time_greater_than,
                rule.actions.base_blob.tier_to_archive_after_days_since_creation_greater_than,
                rule.actions.base_blob.tier_to_archive_after_days_since_last_tier_change_greater_than,
                rule.actions.base_blob.tier_to_cold_after_days_since_modification_greater_than,
                rule.actions.base_blob.tier_to_cold_after_days_since_last_access_time_greater_than,
                rule.actions.base_blob.tier_to_cold_after_days_since_creation_greater_than,
                rule.actions.base_blob.delete_after_days_since_modification_greater_than,
                rule.actions.base_blob.delete_after_days_since_last_access_time_greater_than,
                rule.actions.base_blob.delete_after_days_since_creation_greater_than
              ] : (value == null || (value >= 0 && value <= 99999))
            ]) &&
            (
              (rule.actions.base_blob.tier_to_cool_after_days_since_modification_greater_than != null ? 1 : 0) +
              (rule.actions.base_blob.tier_to_cool_after_days_since_last_access_time_greater_than != null ? 1 : 0) +
              (rule.actions.base_blob.tier_to_cool_after_days_since_creation_greater_than != null ? 1 : 0)
            ) <= 1 &&
            (
              (rule.actions.base_blob.tier_to_archive_after_days_since_modification_greater_than != null ? 1 : 0) +
              (rule.actions.base_blob.tier_to_archive_after_days_since_last_access_time_greater_than != null ? 1 : 0) +
              (rule.actions.base_blob.tier_to_archive_after_days_since_creation_greater_than != null ? 1 : 0)
            ) <= 1 &&
            (
              (rule.actions.base_blob.tier_to_cold_after_days_since_modification_greater_than != null ? 1 : 0) +
              (rule.actions.base_blob.tier_to_cold_after_days_since_last_access_time_greater_than != null ? 1 : 0) +
              (rule.actions.base_blob.tier_to_cold_after_days_since_creation_greater_than != null ? 1 : 0)
            ) <= 1 &&
            (
              (rule.actions.base_blob.delete_after_days_since_modification_greater_than != null ? 1 : 0) +
              (rule.actions.base_blob.delete_after_days_since_last_access_time_greater_than != null ? 1 : 0) +
              (rule.actions.base_blob.delete_after_days_since_creation_greater_than != null ? 1 : 0)
            ) <= 1 &&
            (
              rule.actions.base_blob.auto_tier_to_hot_from_cool_enabled == null ||
              rule.actions.base_blob.auto_tier_to_hot_from_cool_enabled == false ||
              rule.actions.base_blob.tier_to_cool_after_days_since_last_access_time_greater_than != null
            )
          )
          &&
          try(rule.actions.snapshot, null) == null ? true : (
            alltrue([
              for value in [
                rule.actions.snapshot.change_tier_to_cool_after_days_since_creation,
                rule.actions.snapshot.change_tier_to_archive_after_days_since_creation,
                rule.actions.snapshot.tier_to_archive_after_days_since_last_tier_change_greater_than,
                rule.actions.snapshot.tier_to_cold_after_days_since_creation_greater_than,
                rule.actions.snapshot.delete_after_days_since_creation_greater_than
              ] : (value == null || (value >= 0 && value <= 99999))
            ]) &&
            (
              (rule.actions.snapshot.change_tier_to_cool_after_days_since_creation != null ? 1 : 0) +
              (rule.actions.snapshot.change_tier_to_archive_after_days_since_creation != null ? 1 : 0) +
              (rule.actions.snapshot.tier_to_cold_after_days_since_creation_greater_than != null ? 1 : 0)
            ) <= 1
          )
          &&
          try(rule.actions.version, null) == null ? true : (
            alltrue([
              for value in [
                rule.actions.version.change_tier_to_cool_after_days_since_creation,
                rule.actions.version.change_tier_to_archive_after_days_since_creation,
                rule.actions.version.tier_to_archive_after_days_since_last_tier_change_greater_than,
                rule.actions.version.tier_to_cold_after_days_since_creation_greater_than,
                rule.actions.version.delete_after_days_since_creation
              ] : (value == null || (value >= 0 && value <= 99999))
            ]) &&
            (
              (rule.actions.version.change_tier_to_cool_after_days_since_creation != null ? 1 : 0) +
              (rule.actions.version.change_tier_to_archive_after_days_since_creation != null ? 1 : 0) +
              (rule.actions.version.tier_to_cold_after_days_since_creation_greater_than != null ? 1 : 0)
            ) <= 1
          )
          &&
          (
            (
              rule.actions.base_blob != null && (
                rule.actions.base_blob.tier_to_cool_after_days_since_last_access_time_greater_than != null ||
                rule.actions.base_blob.tier_to_archive_after_days_since_last_access_time_greater_than != null ||
                rule.actions.base_blob.tier_to_cold_after_days_since_last_access_time_greater_than != null ||
                rule.actions.base_blob.delete_after_days_since_last_access_time_greater_than != null
              )
            ) ? (try(var.blob_properties.last_access_time_enabled, false) == true) : true
          )
        ])
      ])
    )
    error_message = "'management_policy' rules must include valid blob_types (blockBlob/appendBlob), match_blob_index_tag.operation must be ==, enabled policies must include at least one rule, base_blob tier/delete targets must be mutually exclusive with auto_tier_to_hot_from_cool_enabled requiring tier_to_cool_after_days_since_last_access_time_greater_than, snapshot/version tiering options are mutually exclusive, values must be 0-99999, and last_access_time_enabled must be true when using last-access-time conditions."
  }
}

variable "storage_queues" {
  description = <<EOF
  (Optional) Storage queues to create.
    name : (Required) The name of the Queue which should be created within the Storage Account. Must be unique within the storage account the queue is located. Changing this forces a new resource to be created.
    metadata : (Optional) A mapping of MetaData which should be assigned to this Storage Queue.
  EOF
  type = list(object({
    name     = string
    metadata = optional(map(string))
  }))
  default = []
}

variable "storage_tables" {
  description = <<EOF
  (Optional) Storage tables to create.
    name : (Required) The name of the storage table. Only Alphanumeric characters allowed, starting with a letter. Must be unique within the storage account the table is located. Changing this forces a new resource to be created.
    acl : (Optional) One or more `acl` blocks as defined below.
      id : (Required) The ID which should be used for this Shared Identifier.
      access_policy : (Optional) An `access_policy` block as defined below.
        start : (Required) The ISO8061 UTC time at which this Access Policy should be valid from.
        expiry : (Required) The ISO8061 UTC time at which this Access Policy should be valid until.
        permissions : (Required) The permissions which should associated with this Shared Identifier.
  EOF
  type = list(object({
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
  default = []

  validation {
    condition = alltrue([
      for table in var.storage_tables : alltrue([
        for entry in table.acl : (
          entry.access_policy == null || (
            length(trimspace(entry.access_policy.start)) > 0 &&
            length(trimspace(entry.access_policy.expiry)) > 0 &&
            length(trimspace(entry.access_policy.permissions)) > 0
          )
        )
      ])
    ])
    error_message = "storage_tables.acl access_policy must include non-empty start, expiry, and permissions when set."
  }
}



variable "private_endpoint" {
  description = <<EOF
  (Optional) Private endpoint configuration. If provided, a private endpoint is created.
    name : (Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created.
    resource_group_name : (Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created.
    location : (Required) The supported Azure location where the resource exists. Changing this forces a new resource to be created.
    subnet_id : (Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created.
    custom_network_interface_name : (Optional) The custom name of the network interface attached to the private endpoint. Changing this forces a new resource to be created.
    tags : (Optional) A mapping of tags to assign to the resource.
    private_service_connection : (Required) A `private_service_connection` block as defined below.
      name : (Required) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created.
      is_manual_connection : (Required) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created.
      private_connection_resource_id : (Optional) The ID of the Private Link Enabled Remote Resource to connect to. One of this or `private_connection_resource_alias` must be specified.
      private_connection_resource_alias : (Optional) The Service Alias of the Private Link Enabled Remote Resource to connect to. One of this or `private_connection_resource_id` must be specified.
      subresource_names : (Optional) A list of subresource names which the Private Endpoint is able to connect to.
      request_message : (Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection. Only valid if `is_manual_connection` is `true`.
    private_dns_zone_group : (Optional) One or more `private_dns_zone_group` blocks as defined below.
      name : (Required) Specifies the Name of the Private DNS Zone Group.
      private_dns_zone_ids : (Required) Specifies the list of Private DNS Zones to include within the `private_dns_zone_group`.
    ip_configuration : (Optional) One or more `ip_configuration` blocks as defined below.
      name : (Required) Specifies the Name of the IP Configuration. Changing this forces a new resource to be created.
      private_ip_address : (Required) Specifies the static IP address within the private endpoint's subnet to be used. Changing this forces a new resource to be created.
      subresource_name : (Optional) Specifies the subresource this IP address applies to.
      member_name : (Optional) Specifies the member name this IP address applies to. If it is not specified, it will use the value of `subresource_name`.
  EOF
  type = object({
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
  default = null

  validation {
    condition = var.private_endpoint == null ? true : (
      length(trimspace(var.private_endpoint.subnet_id)) > 0 &&
      length(trimspace(var.private_endpoint.name)) > 0 &&
      length(trimspace(var.private_endpoint.resource_group_name)) > 0 &&
      length(trimspace(var.private_endpoint.location)) > 0 &&
      length(trimspace(var.private_endpoint.private_service_connection.name)) > 0 &&
      (
        var.private_endpoint.private_service_connection.private_connection_resource_id != null ||
        var.private_endpoint.private_service_connection.private_connection_resource_alias != null
      ) &&
      (
        var.private_endpoint.private_service_connection.request_message == null ||
        var.private_endpoint.private_service_connection.is_manual_connection == true
      ) &&
      (
        var.private_endpoint.private_service_connection.request_message == null ||
        length(var.private_endpoint.private_service_connection.request_message) <= 140
      )
    )
    error_message = "private_endpoint must include name, location, resource_group_name, subnet_id, and private_service_connection details with a resource id or alias. request_message requires is_manual_connection = true and must be 140 characters or fewer."
  }
}
