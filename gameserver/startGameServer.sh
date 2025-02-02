#!/bin/bash

echo "=============================="
echo "Iniciando aCis GameServer Console"
echo "=============================="

# Número máximo de tentativas
max_tentativas=3
tentativa=0

# Diretório base para garantir que as chamadas usem o diretório correto
BASE_DIR="$(dirname "$(readlink -f "$0")")"
cd "$BASE_DIR" || exit 1

# Configuração do CLASSPATH (ajustado)
CLASSPATH="./libs/*:./libs/aCis-384.jar"

# Loop para reiniciar até 3 vezes
while [ $tentativa -lt $max_tentativas ]; do
    ((tentativa++))
    echo "Tentativa $tentativa de $max_tentativas..."

    # Verifica a versão do Java instalada
    java -version

    # Inicia o GameServer com o classpath configurado
  nohup   java -Xmx2G -cp "$CLASSPATH" net.sf.l2j.gameserver.GameServer 2>&1 | tee log/stdout.log
    exit_code=$?

    if [ $exit_code -eq 2 ]; then
        echo
        echo "Admin solicitou reinício. Tentando novamente..."
        echo
        continue
    elif [ $exit_code -eq 1 ]; then
        echo
        echo "Erro fatal: O servidor foi encerrado de forma anormal."
        echo
        break
    else
        echo
        echo "Servidor encerrado normalmente."
        echo
        break
    fi
done

if [ $tentativa -ge $max_tentativas ]; then
    echo
    echo "Número máximo de tentativas ($max_tentativas) atingido. Encerrando."
    echo
fi
