output "public_ips" {
  value = merge(
    {
      asgard = oci_core_instance.asgard
    },
    {
      for name, instance in oci_core_instance.amd :
      lower(name) => instance.public_ip
    }
  )
}

# output "hosts_inventory" {
#   value = {
#     schema_version = 2
#
#     hosts = concat(
#       # [
#       #   {
#       #     name        = "Asgard"
#       #     address     = oci_core_instance.asgard.public_ip
#       #     groups      = ["swarm", "swarm_managers"]
#       #     docker_root = "/srv/docker"
#       #     connection  = "ssh"
#       #   }
#       # ],
#       [
#         for name, instance in oci_core_instance.amd : {
#           name        = name
#           address     = instance.public_ip
#           groups      = ["swarm", "swarm_workers"]
#           docker_root = "/srv/docker"
#           connection  = "ssh"
#         }
#       ]
#     )
#   }
# }
