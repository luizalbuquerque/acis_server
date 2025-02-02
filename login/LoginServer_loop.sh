#!/bin/bash

echo "=============================="
echo "Iniciando aCis LoginServer Console"
echo "=============================="

while true; do
    # Verifica a versão do Java
    java -version

    # Inicia o LoginServer
   nohup  java -Xmx32m -cp "./libs/*" net.sf.l2j.loginserver.LoginServer
    exit_code=$?

    if [ $exit_code -eq 2 ]; then
        echo
        echo "Admin solicitou reinício. Reiniciando..."
        echo
        continue
    elif [ $exit_code -eq 1 ]; then
        echo
        echo "O servidor foi encerrado de forma anormal. Encerrando script."
        echo
        break
    else
        echo
        echo "Servidor encerrado normalmente."
        echo
        break
    fi
done

echo "=============================="
echo "Script encerrado."
echo "=============================="
