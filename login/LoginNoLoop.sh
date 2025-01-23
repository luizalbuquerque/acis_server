#!/bin/bash

echo "=============================="
echo "Iniciando aCis LoginServer Console"
echo "=============================="

# Verifica a versão do Java instalada
java -version

# Inicia o LoginServer com o classpath configurado
java -Xmx32m -cp "./libs/*" net.sf.l2j.loginserver.LoginServer
exit_code=$?

if [ $exit_code -eq 2 ]; then
    echo
    echo "Reinício solicitado. O script não foi configurado para reiniciar automaticamente. Encerrando."
    echo
elif [ $exit_code -eq 1 ]; then
    echo
    echo "Erro fatal: O servidor foi encerrado de forma anormal."
    echo
else
    echo
    echo "Servidor encerrado normalmente."
    echo
fi

echo "=============================="
echo "Script finalizado."
echo "=============================="
