resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_name}"
  location = "${var.location}"
  
  tags = {
    environment = "Terraform script"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["${var.vnet_address}"]
  
  tags = {
    environment = "Terraform script"
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${var.subnet_name1}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.subnet_name1_address}"  
}
resource "azurerm_subnet" "subnet2" {
  name                 = "${var.subnet_name2}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.subnet_name2_address}"  
}
resource "azurerm_subnet" "subnet3" {
  name                 = "${var.subnet_name3}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.subnet_name3_address}"  
}

resource "azurerm_network_security_group" "subnet1nsg" {
    name                = "subnet1nsg"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
        
        security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "subnet2nsg" {
    name                = "subnet2nsg"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    
        security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "10.0.0.0/24"
        destination_address_prefix = "*"
      }
      
        security_rule {
        name                       = "DenyAll"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      }
}


resource "azurerm_network_security_group" "subnet3nsg" {
    name                = "subnet3nsg"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
      security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}

### NSG Association should be create together, otherwise it will break the existing association !!!
resource "azurerm_subnet_network_security_group_association" "subnet1nsglink" {
    subnet_id = "${azurerm_subnet.subnet1.id}"
    network_security_group_id = "${azurerm_network_security_group.subnet1nsg.id}"
    
}
resource "azurerm_subnet_network_security_group_association" "subnet2nsglink" {
    subnet_id = "${azurerm_subnet.subnet2.id}"
    network_security_group_id = "${azurerm_network_security_group.subnet2nsg.id}"
    
}

resource "azurerm_subnet_network_security_group_association" "subnet3nsglink" {
    subnet_id = "${azurerm_subnet.subnet3.id}"
    network_security_group_id = "${azurerm_network_security_group.subnet3nsg.id}"
    
}