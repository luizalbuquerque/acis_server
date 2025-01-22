#!/bin/bash

echo "=============================="
echo "Verificando diretório de logs"
echo "=============================="

# Verifica se o diretório "log" existe, e cria se necessário
if ! [ -d ./log/ ]; then
    echo "Diretório ./log/ não encontrado. Criando..."
    mkdir log
    echo "Diretório ./log/ criado com sucesso."
else
    echo "Diretório ./log/ já existe."
fi

# Início do loop para monitorar e reiniciar o LoginServer
err=1
until [ $err == 0 ]; do

    echo "=============================="
    echo "Verificando e movendo logs antigos"
    echo "=============================="

    # Movendo o log antigo java0.log.0
    [ -f log/java0.log.0 ] && mv log/java0.log.0 "log/`date +%Y-%m-%d_%H-%M-%S`_java.log"

    # Movendo o log antigo stdout.log
    [ -f log/stdout.log ] && mv log/stdout.log "log/`date +%Y-%m-%d_%H-%M-%S`_stdout.log"

    echo "=============================="
    echo "Iniciando o LoginServer com alta prioridade"
    echo "=============================="

    # Executando o LoginServer com prioridade alta
    nice -n -2 java -Xmx32m -cp ./libs/*:l2jserver.jar net.sf.l2j.loginserver.LoginServer > log/stdout.log 2>&1

    # Captura o código de saída do comando anterior
    err=$?

    # Mensagem para reiniciar se houver falha
    if [ $err -ne 0 ]; then
        echo "Erro ao executar LoginServer. Código de saída: $err"
    fi

    echo "=============================="
    echo "Aguardando antes de reiniciar"
    echo "=============================="
    sleep 10
done
