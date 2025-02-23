terraform {
  cloud {

    organization = "hsan-hc-jp"

    workspaces {
      name = "master-vpc"
    }
  }
}


