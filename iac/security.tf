resource "azurerm_ssh_public_key" "keypair" {
  name = "key-poc-azure"
  resource_group_name = var.resourceGroup
  location = var.region
  public_key = file("~/.ssh/id_rsa.pub")
}