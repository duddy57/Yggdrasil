# Yggdrasil

Esse repositorio é uma base de como estruturo todos os meus servidores, que se conversam em um rede privada, ele serve como um registro de todos os meus estudos em infra

## Maquinas

Atualmente conto com 3 servidores da oracle e um maquina fisica que utilizo para ferramentas que precisam de um IP residencial sem ter que paga por um proxy ou serviços pessoais, a ideia é aumenta a quantidade de maquinas e serviços

Como o repositorio se chama Yggdrasil da mitologia nordica, as maquinas não podia ser diferente, estou nomeando elas por mundos nordicos

1 - Asgard(Servidor Oracle principal)
2 - Midgard(Maquina Fisica)
3 - Jotunheim(2 Servidor Oracle secundario, que utilizo para workloads)

## Controle

Todas as maquinas estão conectadas a uma rede privada, que utilizo para controle e gerenciamento pela maquina Asgard, utilizo o Komodo nela e nas demais uso o periphery

docker exec -it erp-backend-1 \
bench new-site erp.sperium.net \
--mariadb-user-host-login-scope='%' \
--db-root-username=root \
--db-root-password='D56bLkF2rctiyWDPpb8Gf8mY5zv3QfSn' \
--admin-password='m5L8AtMYAhzzs6WGfQpLsQbCMkd5z4FZ' \
--install-app erpnext

      s arquivos foram ajustados e criados conforme solicitado:

1. Stack central LGTP — composes/utils/lgtp.compose.yml

• Grafana: mantido com as configurações e mapeamentos originais (/var/lib/grafana,
/etc/grafana/provisioning/datasources, /etc/grafana/provisioning/dashboards).
• Prometheus: ajustado para restart: unless-stopped, porta ${GRAFANA_IP_HOST}:9090:9090 (para receber
remote_write do Alloy) e mapeamento seguindo o padrão do Grafana (/var/lib/prometheus:/prometheus e
/etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro).
• Loki: adicionado com grafana/loki:latest, porta ${GRAFANA_IP_HOST}:3100:3100 e mapeamento
/var/lib/loki:/loki + /etc/loki/loki-config.yaml:/etc/loki/local-config.yaml:ro.
• Tempo: adicionado com grafana/tempo:latest, portas ${GRAFANA_IP_HOST}:3200:3200, 4317:4317 (OTLP gRPC) e
4318:4318 (OTLP HTTP), e mapeamento /var/lib/tempo:/var/tempo + /etc/tempo/tempo.yaml:/etc/tempo/tempo.yaml:ro.

2. Alloy em Swarm (arquivo separado) — composes/utils/alloy.compose.yml

• Configurado com deploy.mode: global para subir automaticamente uma réplica em cada máquina do Swarm, usando
hostname: "{{.Node.Hostname}}" e a rede externa network_monitoring.
• Recebe LGTP_HOST=${GRAFANA_IP_HOST} e HOST_HOSTNAME={{.Node.Hostname}} para identificar cada nó e enviar
métricas, logs e traces para a stack LGTP.

3. Arquivos de configuração em observabilidade/

• observabilidade/alloy/config.alloy: coleta métricas do host (prometheus.exporter.unix), métricas de
containers (prometheus.exporter.cadvisor), logs Docker (loki.source.docker) e traces OTLP (otelcol.receiver.
otlp), enviando via remote_write para o Prometheus, loki.write para o Loki e otelcol.exporter.otlp para o
Tempo.
• observabilidade/loki/loki-config.yaml: configuração single-binary do Loki com schema v13/tsdb e retenção de
168h.
• observabilidade/tempo/tempo.yaml: configuração do Tempo com OTLP gRPC/HTTP (4317/4318), storage local em
/var/tempo e retenção de 168h.
• observabilidade/grafana/provisioning/datasources/prometheus.yml: atualizado com os datasources do Prometheus
(http://prometheus:9090), Loki (http://loki:3100) e Tempo (http://tempo:3200) integrados.

│ Note
│ Lembre-se de copiar os arquivos de observabilidade/ para /etc/prometheus/prometheus.yml, /etc/loki/loki-
│ config.yaml, /etc/tempo/tempo.yaml, /etc/grafana/provisioning/datasources/ (no host LGTP) e
│ /etc/alloy/config.alloy (nos nós do Swarm) antes de subir as stacks.

Validação: Todos os YAMLs passaram na verificação sintática e docker compose -f
composes/utils/lgtp.compose.yml config --quiet validou sem erros.
