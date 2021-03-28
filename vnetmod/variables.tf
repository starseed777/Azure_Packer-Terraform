variable azure_rg {
    type = "string"
    default = "terraformprovision"
}

variable azure_blob_rg {
    type = "string"
    default = "terraform"
}

variable azure_location {
    type = "string"
    default = "eastus"
}

variable vnet_cidr {
    type = "string"
    default = "10.0.0.0/16"
}

variable vnet_sub1 {
    type = "string"
    default = "10.0.1.0/24"
}

variable vnet_sub2 {
    type = "string"
    default = "10.0.2.0/24"
}

variable vm_type {
    type = "string"
    default = "Standard_B1s"
}

