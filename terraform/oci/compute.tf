locals {
  ssh_key = trimspace(file(pathexpand(var.ssh_authorized_keys_path)))
}



data "oci_core_images" "ubuntu_arm" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04 Minimal aarch64"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_images" "ubuntu_amd" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04 Minimal"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "asgard" {
  compartment_id      = var.compartment_ocid
  display_name        = "Asgard"
  availability_domain = data.oci_identity_availability_domains.ad.availability_domains[0].name
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "nic-asgard"
    assign_public_ip = true
    hostname_label   = "asgard"
  }

  metadata = {
    ssh_authorized_keys = local.ssh_key
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_amd.images[0].id
    boot_volume_size_in_gbs = 100
  }

  timeouts {
    create = "20m"
  }
}

resource "oci_core_instance" "amd" {
  for_each = {
    Muspelheim = "muspelheim"
    Niflheim   = "niflheim"
  }

  compartment_id      = var.compartment_ocid
  display_name        = each.key
  availability_domain = data.oci_identity_availability_domains.ad.availability_domains[1].name
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "nic-${each.value}"
    assign_public_ip = true
    hostname_label   = each.value
  }

  metadata = {
    ssh_authorized_keys = local.ssh_key
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_amd.images[0].id
    boot_volume_size_in_gbs = 50
  }

  timeouts {
    create = "20m"
  }
}
