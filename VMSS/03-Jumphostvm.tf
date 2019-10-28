data "azurerm_subnet" "subnet-jb" {
  name                 = "${var.subnet_name3}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_public_ip" "jumpbox" {
 name                         = "jumpbox-public-ip"
 location                     = "${var.location}"
 resource_group_name          = "${var.rg_name}"
 allocation_method = "Static"
 domain_name_label            = "${random_string.fqdn.result}-ssh"
 tags                         = "${var.tags}"
}

resource "azurerm_network_interface" "jumpbox" {
 name                = "jumpbox-nic"
 location            = "${var.location}"
 resource_group_name = "${var.rg_name}"

 ip_configuration {
   name                          = "IPConfiguration"
   subnet_id                     = "${data.azurerm_subnet.subnet-jb.id}"
   private_ip_address_allocation = "dynamic"
   public_ip_address_id          = "${azurerm_public_ip.jumpbox.id}"
 }

 tags = "${var.tags}"
}

resource "azurerm_virtual_machine" "jumpbox" {
 name                  = "jumpbox"
 location              = "${var.location}"
 resource_group_name   = "${var.rg_name}"
 network_interface_ids = ["${azurerm_network_interface.jumpbox.id}"]
 vm_size               = "Standard_DS1_v2"

 storage_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }

 storage_os_disk {
   name              = "jumpbox-osdisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 os_profile {
   computer_name  = "jumpbox"
   admin_username = "${var.username}"
   admin_password = "${var.password}"
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 tags = "${var.tags}"
}