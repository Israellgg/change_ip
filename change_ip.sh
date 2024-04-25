#!/bin/bash

# Defina o novo endereço IP, gateway e servidores DNS
NEW_IP="192.168.199.129/24"
NEW_GATEWAY="192.168.199.5"
NEW_DNS="192.168.0.4, 192.168.0.8"

# Caminho para o arquivo de configuração netplan
NETPLAN_CONFIG="/etc/netplan/00-installer-config.yaml"

# Verificar se o arquivo de configuração existe
if [ ! -f "$NETPLAN_CONFIG" ]; then
    echo "Erro: Arquivo de configuração netplan não encontrado: $NETPLAN_CONFIG"
    exit 1
fi

# Criar o conteúdo do novo arquivo de configuração
NEW_CONFIG=$(cat <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - $NEW_IP
      routes:
        - to: default
          via: $NEW_GATEWAY
      nameservers:
        addresses: [$NEW_DNS]
EOF
)

# Fazer backup do arquivo de configuração original
cp "$NETPLAN_CONFIG" "$NETPLAN_CONFIG.bak"

# Escrever o novo conteúdo no arquivo de configuração
echo "$NEW_CONFIG" > "$NETPLAN_CONFIG"

# Aplicar as alterações de configuração usando netplan apply
netplan apply

echo "Configuração de rede atualizada com sucesso."
