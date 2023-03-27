variable "region" {
  type = string
  default = "francecentral"
}

variable "resourceGroup" {
    type = string
    default = "rg-poc-azure"
}

variable "tags" {
  type = map(string)
  default = {
    "environment" = "lab"
    "client" = "lcube"
    "source" = "terraform"
  }
}