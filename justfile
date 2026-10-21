set dotenv-load

terraform-dir := "terraform/oci-arm"
ansible-dir := "ansible"
inventory := ansible-dir / "inventory/runtime-inventory.json"

# Inicializa os providers e o state Terraform.
terraform:
    terraform -chdir={{ terraform-dir }} init

# Cria/atualiza toda a infraestrutura OCI.
apply: terraform
    terraform -chdir={{ terraform-dir }} apply

# Exporta o inventário inicial com os IPs públicos das VMs.
inventory: apply
    mkdir -p {{ ansible-dir }}/inventory
    terraform -chdir={{ terraform-dir }} output -json hosts_inventory > {{ inventory }}

# # Configura Tailscale, Docker, firewall, Periphery e Swarm.
# ansible: inventory
#     cd {{ansible-dir}} && \
#       ANSIBLE_RUNTIME_INVENTORY_JSON="$$(<inventory/runtime-inventory.json)" \
#       ANSIBLE_REMOTE_USER="$${ANSIBLE_REMOTE_USER:-ansible}" \
#       ansible-playbook playbooks/bootstrap.yml
#
# # Sobe a infraestrutura completa em uma única execução.
# up: ansible

# Apenas mostra o plano Terraform, sem alterar recursos.
plan: terraform
    terraform -chdir={{ terraform-dir }} plan

# Remove a infraestrutura criada pelo Terraform.
down:
    terraform -chdir={{ terraform-dir }} destroy
