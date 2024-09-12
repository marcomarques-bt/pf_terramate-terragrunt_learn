include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "all" {
  path   = "${get_terragrunt_dir()}/../../../../_all/storage-account.hcl"
  expose = true
}

inputs = {
}

terraform {
  source = "tfr:///Azure/avm-res-storage-storageaccount/azurerm?version=0.2.5"
}

