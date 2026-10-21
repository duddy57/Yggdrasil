data "oci_identity_availability_domains" "ad" {
  compartment_id = var.tenancy_ocid
}

output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ad.availability_domains
}
