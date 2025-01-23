#!/bin/bash

echo "Aguardando MySQL iniciar..."

# Esperar MySQL estar disponível
until mysql -u root -proot -h 127.0.0.1 -P 3306 -e "SELECT 1"; do
    echo "Aguardando MySQL iniciar..."
    sleep 2
done

echo "MySQL iniciou com sucesso!"

# Criar o banco de dados 'acis'
echo "Criando o banco de dados acis..."
mysql -u root -proot -h 127.0.0.1 -P 3306 -e 'CREATE DATABASE IF NOT EXISTS acis;'

# Importar os arquivos SQL
echo "Importando os arquivos SQL..."
for file in /tmp/sql/*.sql; do
    echo "Importando $file..."
    mysql -u root -proot acis < "$file"
done

echo "Importação concluída!"
