variable "tenancy_ocid" {
  description = "Tenancy's OCID"
}

variable "user_ocid" {
  description = "User's OCID"
  default     = ""
}

variable "fingerprint" {
  description = "Key Fingerprint"
  default     = ""
}

variable "private_key_path" {
  description = "The private key path to pem."
  default     = ""
}

variable "region" {
  description = "OCI Region"
}

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "ssh_authorized_keys_path" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance."
  default     = ""
}

variable "ssh_private_key_path" {
  description = "The private key path to access instance."
  default     = ""
}

variable "subnet_id" {
  description = "The subnet id"
}
