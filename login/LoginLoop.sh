#!/bin/bash

echo "=============================="
echo "Iniciando aCis LoginServer Console"
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

    # Inicia o LoginServer com o classpath configurado
    java -Xmx32m -cp "$CLASSPATH" net.sf.l2j.loginserver.LoginServer
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



echo "============================================================="
echo "                 MONITORAMENTO DE PROCESSOS                  "
echo "============================================================="
echo ""
echo "USE F3 APÓS O COMANDO HTOP PARA VER PROCESSOS ATIVOS NO HTOP"
echo ""
echo "Significados dos estados dos processos:"
echo ""
echo "R: Running (Executando) – O processo está atualmente em execução."
echo "S: Sleeping (Ocioso) – O processo está ativo, mas aguardando algo (ex.: conexão, E/S)."
echo "D: Uninterruptible sleep (Ocioso não-interruptível) – O processo está aguardando I/O (não pode ser interrompido)."
echo "T: Stopped (Parado) – O processo foi parado (via kill -STOP ou depuração)."
echo "Z: Zombie – O processo terminou, mas ainda tem uma entrada na tabela de processos."
echo ""
echo "============================================================="
