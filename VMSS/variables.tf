variable "rg_name" {
  default = "azVMSS-01"
}
variable "location" {
  default     = "southeastasia"
}
variable "username" {
  default     = "azureuser"
}
variable "password" {
  default     = "Password1234!"
}
variable "vmsize" {
  default     = "Standard_DS1_v2"
}
variable "vnet_name" {
  description = "Vnet to join by VM Scale-Set"
  default = "myVNET"
}
variable "subnet_name" {
  description = "Subnet to join by VM Sacle-Set"
  default = "subnet1"
}

variable "subnet_name2" {
  description = "Subnet to join by VM Sacle-Set"
  default = "subnet2"
}

variable "subnet_name3" {
  description = "Subnet for Jumpbox"
  default = "subnet3"
}

variable "tags" {
 description = "A map of the tags to use for the resources that are deployed"
 type        = "map"

 default = {
   environment = "VM Scale-Set"
 }
}

variable "application_port" {
   description = "The port that you want to expose to the external load balancer"
   default     = 80
}
