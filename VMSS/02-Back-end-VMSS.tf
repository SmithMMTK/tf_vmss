data "azurerm_subnet" "subnet-be" {
  name                 = "${var.subnet_name2}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_lb" "vmss-be" {
 name                = "vmss-lb-be"
 location            = "${var.location}"
 resource_group_name = "${var.rg_name}"


 frontend_ip_configuration {
   name                 = "InternalIPAddress"
   subnet_id            = "${data.azurerm_subnet.subnet-be.id}"
 }

 tags = "${var.tags}"
}

resource "azurerm_lb_backend_address_pool" "bpepool-be" {
 resource_group_name = "${var.rg_name}"
 loadbalancer_id     = "${azurerm_lb.vmss-be.id}"
 name                = "BackEndAddressPool-be"
}

resource "azurerm_lb_probe" "vmss-be" {
 resource_group_name = "${var.rg_name}"
 loadbalancer_id     = "${azurerm_lb.vmss-be.id}"
 name                = "ssh-running-probe-be"
 port                = "${var.application_port}"
}

resource "azurerm_lb_rule" "lbnatrule-be" {
   resource_group_name            = "${var.rg_name}"
   loadbalancer_id                = "${azurerm_lb.vmss-be.id}"
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = "${var.application_port}"
   backend_port                   = "${var.application_port}"
   backend_address_pool_id        = "${azurerm_lb_backend_address_pool.bpepool-be.id}"
   frontend_ip_configuration_name = "InternalIPAddress"
   probe_id                       = "${azurerm_lb_probe.vmss-be.id}"
}

resource "azurerm_virtual_machine_scale_set" "vmss-be" {
 name                = "vmscaleset-be"
 location            = "${var.location}"
 resource_group_name = "${var.rg_name}"
 upgrade_policy_mode = "Manual"

 sku {
   name     = "Standard_DS1_v2"
   tier     = "Standard"
   capacity = 2
 }

 storage_profile_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }

 storage_profile_os_disk {
   name              = ""
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_profile_data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
 }

 os_profile {
   computer_name_prefix = "vmlab-be"
   admin_username       = "${var.username}"
   admin_password       = "${var.password}"
   custom_data          = "${file("cloud-init.txt")}"
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 network_profile {
   name    = "terraformnetworkprofile-be"
   primary = true

   ip_configuration {
     name                                   = "IPConfiguration"
     subnet_id                              = "${data.azurerm_subnet.subnet-be.id}"
     load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool-be.id}"]
     primary = true
   }
 }

 tags = "${var.tags}"
}