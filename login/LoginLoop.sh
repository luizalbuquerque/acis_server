#!/bin/bash

echo "================================="
echo "Iniciando aCis LoginServer Console"
echo "================================="

# Porta usada pelo servidor de login
PORT=2106

# Verificar e encerrar qualquer processo que esteja usando a porta 2106
echo "Verificando se a porta $PORT está em uso..."
pid=$(sudo lsof -t -i:$PORT)
if [ ! -z "$pid" ]; then
    echo "Encerrando processo $pid que está usando a porta $PORT..."
    sudo kill -9 $pid
    if [ $? -eq 0 ]; then
        echo "Processo encerrado com sucesso."
    else
        echo "Falha ao encerrar o processo."
        exit 1
    fi
else
    echo "Nenhuma porta $PORT em uso."
fi

# Configurações adicionais e a inicialização do servidor...
# Número máximo de tentativas
max_tentativas=3
tentativa=0

# Diretório base para garantir que as chamadas usem o diretório correto
BASE_DIR="$(dirname "$(readlink -f "$0")")"
cd "$BASE_DIR" || exit 1

# Loop para reiniciar até 3 vezes
while [ $tentativa -lt $max_tentativas ]; do
    ((tentativa++))
    echo "Tentativa $tentativa de $max_tentativas..."

    # Inicia o LoginServer com o classpath configurado
    java -Xmx32m -cp "$CLASSPATH" net.sf.l2j.loginserver.LoginServer
    exit_code=$?

    if [ $exit_code -eq 2 ]; then
        echo "Admin solicitou reinício. Tentando novamente..."
        continue
    elif [ $exit_code -eq 1 ]; then
        echo "Erro fatal: O servidor foi encerrado de forma anormal."
        break
    else
        echo "Servidor encerrado normalmente."
        break
    fi
done

if [ $tentativa -ge $max_tentativas ]; then
    echo "Número máximo de tentativas ($max_tentativas) atingido. Encerrando."
fi
