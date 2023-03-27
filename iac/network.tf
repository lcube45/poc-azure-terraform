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
}

resource "azurerm_subnet_route_table_association" "publicSubnetRouteTableAssociation" {
    subnet_id = azurerm_subnet.publicSubnet.id
    route_table_id = azurerm_route_table.publicSubnetRouteTable.id
}

resource "azurerm_subnet_route_table_association" "privateSubnetRouteTableAssociation" {
    subnet_id = azurerm_subnet.privateSubnet.id
    route_table_id = azurerm_route_table.privateSubnetRouteTable.id
}

resource "azurerm_public_ip" "natGwPublicIp" {
    name = "natgw-ip"
    resource_group_name = var.resourceGroup
    location = var.region
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_nat_gateway" "natGw" {
    name = "natgw-poc-azure-01"
    location = var.region
    resource_group_name = var.resourceGroup
    sku_name = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "natGwPublicIpAssociation" {
    nat_gateway_id = azurerm_nat_gateway.natGw.id
    public_ip_address_id = azurerm_public_ip.natGwPublicIp.id
}

resource "azurerm_subnet_nat_gateway_association" "privateSubnetNatGwAssociation" {
    subnet_id = azurerm_subnet.privateSubnet.id
    nat_gateway_id = azurerm_nat_gateway.natGw.id
}