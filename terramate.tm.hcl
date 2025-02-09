
terramate {
  config {
    git {
      default_branch = "main"
    }
  }
}

globals {
  env = "test"
}


generate_hcl "backend.tf" {
  content {
    terraform {
      backend "local" {
        path = "terraform.tfstate"
      }
    }
  }
}

generate_hcl "terramate_provider.tf" {
  content {
    provider "kubernetes" {
        config_path = "~/.kube/config"
    }

    provider "helm" {
        kubernetes {
            config_path = "~/.kube/config"
        }
    }
  }
}

generate_hcl "terramate_vars_global.tf" {
  content {
    variable "env" {
      default = "${global.env}"
    }
  }
}