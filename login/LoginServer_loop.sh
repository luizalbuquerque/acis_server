#!/bin/bash

echo "=============================="
echo "Iniciando aCis LoginServer Console"
echo "=============================="


echo "========================================="
echo "Fechando processos antigos gameserver  .."
sudo pkill -f net.sf.l2j.gameserver.GameServer
echo "Fechando processos antigos loginserver .."
sudo pkill -f net.sf.l2j.loginserver.LoginServer
sleep 5
echo "========================================="


while true; do
    # Verifica a versão do Java
    java -version

    # Inicia o LoginServer
    java -Xmx32m -cp "./libs/*" net.sf.l2j.loginserver.LoginServer
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
