# Azure Storage Account Terraform Module

Terraform module to provision an Azure Storage Account with optional networking, encryption, data plane objects, and private endpoint integration.

## Permissions

To provision the Azure resources managed by this module, the identity running Terraform needs permissions such as:

- `Contributor` (for resource group and Storage Account/Private Endpoint resource lifecycle operations).
- `Storage Blob Data Contributor` (required for blob container/blob data-plane operations managed by this module).
- `Storage Queue Data Contributor` (required for queue data-plane operations managed by this module).
- `Storage Table Data Contributor` (required for table data-plane operations managed by this module).
- `Network Contributor` (required on the target virtual network/subnet used by private endpoints).
- `Key Vault Crypto Service Encryption User` (required when using customer-managed keys in Key Vault for storage account encryption).
- `Private DNS Zone Contributor` (required when configuring `private_dns_zone_group` with private endpoint integration).

## Authentications

Authentication to Azure can be configured using one of the following methods:

### Service Principal and Client Secret

Use an Azure AD service principal for non-interactive runs (CI/CD, automation).

You can configure this method in either of the following ways:

- **Inside the provider block**

  ```hcl
  provider "azurerm" {
    features {}

    subscription_id = "<subscription-id>"
    tenant_id       = "<tenant-id>"
    client_id       = "<client-id>"
    client_secret   = "<client-secret>"
  }
  ```

- **Using environment variables**

  - `ARM_SUBSCRIPTION_ID`
  - `ARM_TENANT_ID`
  - `ARM_CLIENT_ID`
  - `ARM_CLIENT_SECRET`

### Managed Service Identity

Use Managed Identity when Terraform runs on Azure-hosted compute (for example, Azure VM, VMSS, App Service, AKS).

- **Inside the provider block**

  ```hcl
  provider "azurerm" {
    features {}
    use_msi = true
  }
  ```

- **Using environment variables**

  - `ARM_USE_MSI=true`
  - `ARM_SUBSCRIPTION_ID`
  - `ARM_TENANT_ID` (optional in some environments, but recommended for clarity)

Documentation:

- [Authenticating to Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure)
- [Service Principal and Client Secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
- [Managed Service Identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/managed_service_identity)

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
