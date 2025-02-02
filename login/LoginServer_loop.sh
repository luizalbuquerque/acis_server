#!/bin/bash

echo "=============================="
echo "Iniciando aCis LoginServer Console"
echo "=============================="

# Verifica a versão do Java
java -version

# Inicia o LoginServer em segundo plano e libera o terminal
nohup java -Xmx32m -cp "./libs/*" net.sf.l2j.loginserver.LoginServer > loginserver.out 2>&1 &

# Aguarda o término do processo em segundo plano e obtém o código de saída
wait $!
exit_code=$?

if [ $exit_code -eq 2 ]; then
    echo
    echo "Admin solicitou reinício. Reiniciando..."
    echo
elif [ $exit_code -eq 1 ]; then
    echo
    echo "O servidor foi encerrado de forma anormal. Encerrando script."
    echo
else
    echo
    echo "Servidor encerrado normalmente."
    echo
fi

echo "=============================="
echo "Script encerrado."
echo "=============================="
