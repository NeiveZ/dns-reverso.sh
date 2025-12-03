#!/bin/bash

# --- Coleta de Dados do Usuário ---

echo "--- Configuração do Reconhecimento de DNS Reverso ---"

# Pede o prefixo da rede (ex: 192.168.1)
read -p "Digite o prefixo da rede (ex: 37.59.174): " PREFIXO

# Pede o início da faixa (último octeto)
read -p "Digite o número de IP inicial da faixa (ex: 224): " INICIO_IP

# Pede o fim da faixa (último octeto)
read -p "Digite o número de IP final da faixa (ex: 239): " FIM_IP

# String para filtrar (ajuste conforme necessário, o padrão remove linhas 'not found' comuns)
FILTRO="not found" 

echo "---"
echo "Iniciando DNS Reverso para a faixa: $PREFIXO.$INICIO_IP - $PREFIXO.$FIM_IP"
echo "---"

# --- Execução do Scan ---

# O 'seq' gera a sequência de números entre INICIO_IP e FIM_IP
for ip in $(seq $INICIO_IP $FIM_IP); do
    IP_COMPLETO="$PREFIXO.$ip"
    
    # Executa o lookup, filtra a string 'not found' e extrai o 5º campo (o hostname)
    RESULTADO=$(host -t ptr $IP_COMPLETO | grep -v "$FILTRO" | cut -d " " -f 5)
    
    # Imprime apenas se um resultado válido for encontrado
    if [ ! -z "$RESULTADO" ]; then
        echo "$IP_COMPLETO -> $RESULTADO"
    fi
done

echo "---"
echo "Reconhecimento de DNS Reverso concluído."
