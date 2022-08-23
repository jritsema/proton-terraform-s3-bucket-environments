###########################################################
# This file is used by .github/workflows/proton.yml to 
# supplement deployed proton templates with tf cloud info.
# This is only required due to a current limitation in
# terraform where terraform cloud workspaces
# cannot be dynamically created using variables
# note that ${TF_WORKSPACE} is dynamically replaced
# with the proton environment name
# also see https://discuss.hashicorp.com/t/cloud-block-with-dynamic-workspace-name/34641
###########################################################

terraform {

  cloud {
    organization = "$TF_ORG"

    workspaces {
      name = "$TF_WS"
    }
  }
}
