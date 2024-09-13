terramate {
  required_version = ">= 0.9.0"
  config {

    git {
      # Git configuration
      default_remote = "origin"
      default_branch = "master"

      # Safeguards
      check_untracked   = false
      check_uncommitted = false
      check_remote      = false
    }
    
    # Enable Terramate Scripts
    experiments = [
      "scripts",
    ]
  }
}
