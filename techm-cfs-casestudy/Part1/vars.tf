variable "access_key" {}

variable "secret_key" {}

variable "region" {
    type = string
    description = "AWS region where the Pipeline 1 VM will be provisioned"
    default = "us-east-1"
}

variable "ami" {
    type = string
    description = "Ubuntu AMI for provisiong the Pipeline 1 VM"
}

variable "vm_ssh_public_key" {
    type = string
    description = "ssh public key of the vm"
}
