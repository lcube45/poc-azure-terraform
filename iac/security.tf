resource "azurerm_ssh_public_key" "keypair" {
  name = "key-poc-azure"
  resource_group_name = var.resourceGroup
  location = var.region
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "azurerm_network_security_group" "nsgPublicSubnet" {
  name = "nsg-subnet-public"
  location = var.region
  resource_group_name = var.resourceGroup

  security_rule {
    name = "AllowHTTP"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "80"
    source_address_prefix = "Internet"
    destination_port_range = "80"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name = "AllowSSH"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "22"
    destination_port_range = "22"
    source_address_prefix = "95.128.144.94"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgPublicSubnetAssociation" {
  subnet_id = azurerm_subnet.publicSubnet.id
  network_security_group_id = azurerm_network_security_group.nsgPublicSubnet.id
}

resource "azurerm_network_security_group" "nsgPrivateSubnet" {
  name = "nsg-subnet-private"
  location = var.region
  resource_group_name = var.resourceGroup

  security_rule {
    name = "AllowSSH"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "22"
    destination_port_range = "22"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgPrivateSubnetAssociation" {
  subnet_id = azurerm_subnet.privateSubnet.id
  network_security_group_id = azurerm_network_security_group.nsgPrivateSubnet.id
}