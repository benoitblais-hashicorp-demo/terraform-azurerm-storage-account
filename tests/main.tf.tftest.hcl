run "apply_basic" {
  command = apply

  module {
    source = "./tests/fixtures/basic"
  }

  variables {
    storage_account_name = "st${substr(replace(uuid(), "-", ""), 0, 10)}"
    location             = "eastus"
    resource_group_name  = "rg-${substr(replace(uuid(), "-", ""), 0, 10)}"
  }
}