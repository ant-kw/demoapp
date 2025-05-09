## Don't change defaults here - set them in the env.tfvars
## to override whats set here

variable "gcp_project_id" {
  type        = string
  description = "GCP project we are working in"
  default     = "NONE-SET"
}

variable "env" {
  type        = string
  description = "Environment we are working on"
  default     = "test"
}

variable "region" {
  type        = string
  description = "The Region this will be deployed in"
  default     = "europe-west1"
}

variable "project_services" {
  type        = set(string)
  description = "Project serices to enable"
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "dns.googleapis.com"
  ]
}

variable "project_metadata" {
  type        = map(string)
  description = "Project Metadata labels"
  default = {
  }
}

variable "bucket_location" {
  type        = string
  description = "Default Bucket location for this project"
  default     = "EU"
}

variable "network_ip_range" {
  type        = string
  description = "Network Range to use"
  default     = "10.10.0.0/20"
}

variable "network_services_ip_range" {
  type        = string
  description = "Network Range to use for services"
  default     = "10.10.10.0/20"
}

variable "network_region" {
  type        = string
  description = "The Region where the network will be deployed"
  default     = "europe-west1"
}


variable "inbound_cidrs" {
  description = "A list of inbound IP's"
  type = list(object({
    name  = string
    value = string
  }))

  default = [
    {
      name  = "test_eu_nat_0"
      value = "34.76.45.27/32"
    },
  ]
}

## Bastion

variable "bastion_instance_template" {
  description = "Image name for bastion instance"
  type        = string
  default     = "debian-11"
}

variable "bastion_instance_type" {
  description = "Instance type for bastion instances"
  type        = string
  default     = "e2-micro"
}

variable "bastion_boot_disk_type" {
  description = "The type of disk for bastion"
  type        = string
  default     = "pd-ssd"
}

variable "bastion_boot_disk_size" {
  description = "The size of the bastion boot disk in GB"
  type        = string
  default     = 20
}

variable "bastion_size" {
  description = "How many basion instances to spin up"
  type        = number
  default     = 0
}

## rabbitmq

variable "demoapp-rabbitmq_machine_type" {
  description = "Machine type for the rabbitmq instances"
  type        = string
  default     = "n1-standard-1"
}

variable "demoapp-rabbitmq_src_image" {
  description = "source image for the rabbitmq instances"
  type        = string
  default     = "debian-12" ## - When using packer built image apply family name here
}

variable "demoapp-rabbitmq_boot_disk_type" {
  description = "Type of disk to use for the rabbitmq instances"
  type        = string
  default     = "pd-ssd"
}
variable "demoapp-rabbitmq_boot_disk_size" {
  description = "Size of boot disk for the rabbitmq instances"
  type        = string
  default     = "50"
}

variable "mig_demoapp-rabbitmq_target_size" {
  description = "number of rabbitmq instances to spin up"
  type        = number
  default     = 0
}
