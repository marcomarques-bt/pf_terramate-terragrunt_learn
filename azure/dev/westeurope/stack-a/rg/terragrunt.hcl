include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "all" {
  path   = "${get_path_to_repo_root()}/azure/_all/rg.hcl"
  expose = true
}

inputs = {
}

terraform {
  source = "${get_path_to_repo_root()}/modules//${basename(get_terragrunt_dir())}"
}