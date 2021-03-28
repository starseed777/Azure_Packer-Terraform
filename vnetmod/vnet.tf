resource "azurerm_resource_group" "tfrg" {
  name     = var.azure_rg
  location = var.azure_location
}

resource "azurerm_virtual_network" "terraformvnet" {
  name                = "tfvnet"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  address_space       = [var.vnet_cidr] 
}

resource "azurerm_subnet" "subnet1" {
  name                 = "sub1"
  resource_group_name  = azurerm_resource_group.tfrg.name
  virtual_network_name = azurerm_virtual_network.terraformvnet.name
  address_prefixes     = [var.vnet_sub1]
}

resource "azurerm_public_ip" "publicip" {
    name                         = "myPublicIP"
    location                     = var.azure_location
    resource_group_name          = azurerm_resource_group.tfrg.name
    allocation_method            = "Dynamic"

}

resource "azurerm_network_interface" "terraform-nic" {
  name                = "terraform-nic"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_network_security_group" "ssh" {
  name                = "ssh"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  security_rule {
    name                       = "allow_SSH"
    description                = "Allow SSH access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


data "azurerm_image" "search" {
  name                = "packer_azure"
  resource_group_name = var.azure_blob_rg
}


resource "azurerm_virtual_machine" "packervm1" {
    name = "packervm1"
    location              = azurerm_resource_group.tfrg.location
    resource_group_name   = azurerm_resource_group.tfrg.name
    vm_size = var.vm_type
    network_interface_ids = [azurerm_network_interface.terraform-nic.id]
    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true
    

    storage_image_reference {
        id = data.azurerm_image.search.id
    }

    storage_os_disk {
        name              = "myosdisk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name  = "packervm1"
        admin_username = "azure"
        admin_password = ""
    }

    os_profile_linux_config {
    disable_password_authentication = true 

    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path = "/home/azure/.ssh/authorized_keys"
    }
  }



}

