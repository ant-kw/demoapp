gcp_project_id  = ""
env             = "test"

bucket_location = "EU"

region           = "europe-west1"
network_region   = "europe-west1"
network_ip_range = "10.10.0.0/16"

bastion_size = 0


## rabbitmq

demoapp-rabbitmq_machine_type    = "n1-standard-1"
demoapp-rabbitmq_src_image       = "debian-12" ## - When using packer built image apply family name here
demoapp-rabbitmq_boot_disk_type  = "pd-ssd"
demoapp-rabbitmq_boot_disk_size  = "50"
mig_demoapp-rabbitmq_target_size = 0

