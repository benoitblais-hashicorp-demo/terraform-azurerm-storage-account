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
