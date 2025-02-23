data "terraform_remote_state" "networking" {
  backend = "remote"

  config = {
    organization = "hsan-hc-jp"
    workspaces = {
      name = "master-vpc"
    }
  }
}