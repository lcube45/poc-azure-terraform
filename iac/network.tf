resource "azurerm_virtual_network" "vnet" {
    name = "vnet-poc-azure-01"
    location = var.region
    resource_group_name = var.resourceGroup
    address_space = ["10.0.0.0/16"]
    tags = var.tags
}

resource "azurerm_subnet" "publicSubnet" {
    name = "public-subnet"
    resource_group_name = var.resourceGroup
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "privateSubnet" {
    name = "private-subnet"
    resource_group_name = var.resourceGroup
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_route_table" "publicSubnetRouteTable" {
  name = "rt-subnet-public"
  location = var.region
  resource_group_name = var.resourceGroup
  disable_bgp_route_propagation = true

  route {
    name = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type = "Internet"
  }

  route {
    name = "vnet"
    address_prefix = "10.0.0.0/16"
    next_hop_type = "VnetLocal"
  }
}

resource "azurerm_route_table" "privateSubnetRouteTable" {
    name = "rt-subnet-private"
    location = var.region
    resource_group_name = var.resourceGroup
    disable_bgp_route_propagation = true
    
    route {
        name = "vnet"
        address_prefix = "10.0.0.0/16"
        next_hop_type = "VnetLocal"
    }

    route {
        name = "none"
        address_prefix = "0.0.0.0/0"
        next_hop_type = "None"
    }
}

resource "azurerm_subnet_route_table_association" "publicSubnetRouteTableAssociation" {
    subnet_id = azurerm_subnet.publicSubnet.id
    route_table_id = azurerm_route_table.publicSubnetRouteTable.id
}

resource "azurerm_subnet_route_table_association" "privateSubnetRouteTableAssociation" {
    subnet_id = azurerm_subnet.privateSubnet.id
    route_table_id = azurerm_route_table.privateSubnetRouteTable.id
}