#!/bin/bash

echo "Iniciando o script setup-db.sh..."

# Conectar ao MySQL no container e criar o banco de dados
echo "Acessando o MySQL e criando o banco de dados 'acis'..."

# Aguardar o MySQL estar pronto para conexão
until mysql -u root -proot -h 127.0.0.1 -P 3333 -e "SELECT 1"; do
  echo "Aguardando MySQL iniciar..."
  sleep 2
done

# Criar banco de dados se não existir
mysql -u root -proot -h 127.0.0.1 -P 3333 -e "CREATE DATABASE IF NOT EXISTS acis; USE acis;"

# Verificar o número de tabelas criadas
TABLE_COUNT=$(mysql -u root -proot -h 127.0.0.1 -P 3333 -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'acis';" -N)
echo "O banco de dados 'acis' contém $TABLE_COUNT tabelas."

# Verificar se há arquivos SQL para importar
if [ ! -d /tmp/sql ] || [ -z "$(ls -A /tmp/sql)" ]; then
  echo "Nenhum arquivo SQL encontrado em /tmp/sql. Nenhuma importação será realizada."
  exit 1
fi

# Criar o script de importação de SQL dentro do container
echo "Criando o script de importação de SQL no container..."

# Criação do script de importação de todos os arquivos SQL na pasta /tmp/sql
echo 'for file in /tmp/sql/*.sql; do' > /tmp/import_sql.sh
echo '  echo "Importando $file..."' >> /tmp/import_sql.sh
echo '  mysql -u root -p"root" acis < "$file"' >> /tmp/import_sql.sh
echo 'done' >> /tmp/import_sql.sh

# Tornar o script executável
chmod +x /tmp/import_sql.sh

# Executar o script de importação
echo "Executando o script de importação..."
/tmp/import_sql.sh

# Verificar se houve erro na importação
if [ $? -eq 0 ]; then
  echo "Importação de dados concluída com sucesso."
else
  echo "Erro na importação de dados."
  exit 1
fi
