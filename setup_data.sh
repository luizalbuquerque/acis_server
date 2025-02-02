#!/bin/bash


set -x


echo "================================="
echo "Garantindo permissões de execução"
echo "================================="


# Dá permissão de execução para todos os scripts .sh no diretório atual e subdiretórios
find . -type f -name "*.sh" -exec chmod +x {} \;


# Dá permissão de leitura e execução para todos os arquivos na pasta libs
chmod +r ./libs/*.jar

echo ""
echo "Permissões ajustadas com sucesso."
echo ""



echo "=================================="
echo "Pré Setup: Validando se o container está ativo"
echo "=================================="
docker ps | grep acis_database > /dev/null
if [ $? -ne 0 ]; then
    echo "Container acis_database não está ativo. Tentando iniciar..."
    docker start acis_database
    if [ $? -ne 0 ]; then
        echo "Falha ao iniciar o container acis_database"
        exit 1
    else
        echo "Container acis_database iniciado com sucesso"
    fi
else
    echo "Container acis_database já está ativo"
fi

echo ""
echo "Aguardando o MySQL inicializar..."
sleep 10
echo


echo ""
echo "================================="
echo "Passo 1: Copiando scripts SQL"
echo "================================="
docker cp ./sql acis_database:/tmp/sql
if [ $? -ne 0 ]; then
    echo "Passo 1: Falhou"
    exit 1
else
    echo "Passo 1: Sucesso"
fi

echo ""
echo "================================="
echo "Passo 2: Verificando arquivos copiados"
echo "================================="
docker exec acis_database ls -l /tmp/sql
if [ $? -ne 0 ]; then
    echo "Passo 2: Falhou"
    exit 1
else
    echo "Passo 2: Sucesso"
fi



echo ""
echo "================================="
echo "Passo 3: Criando banco de dados se não existir"
echo "================================="
mysql -u root -proot -P 3333 -e "CREATE DATABASE IF NOT EXISTS acis;"
if [ $? -ne 0 ]; then
    echo "Passo 3: Falhou"
    exit 1
else
    echo "Passo 3: Sucesso"
fi



echo ""
echo "================================="
echo "Passo 4: Validando se o banco foi criado"
echo "================================="
mysql -u root -proot -P 3333 -e "SHOW DATABASES;"
if [ $? -ne 0 ]; then
    echo "Passo 4: Falhou"
    exit 1
else
    echo "Passo 4: Sucesso"
fi



echo ""
echo "================================="
echo "Passo 5: Executando scripts SQL no container"
echo "================================="
docker exec acis_database bash -c 'for file in /tmp/sql/*.sql; do if [ -f "$file" ]; then echo "Importando $file..."; mysql -u root -proot acis < "$file"; else echo "Nenhum arquivo encontrado em /tmp/sql/*.sql"; fi; done'
if [ $? -ne 0 ]; then
    echo "Passo 5: Falhou"
    exit 1
else
    echo "Passo 5: Sucesso"
fi



echo ""
echo "================================="
echo "Passo 6: Validando tabelas criadas no banco"
echo "================================="
mysql -u root -proot -P 3333 -e "USE acis; SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'acis';"
if [ $? -ne 0 ]; then
    echo "Passo 6: Falhou"
    exit 1
else
    echo "Passo 6: Sucesso"
fi



echo ""
echo "================================="
echo "Permissionando LoginLoop.sh..."
echo "================================="

# Garantir permissão e formato correto para o script login/LoginLoop.sh
if [ -f "./login/LoginLoop.sh" ]; then
    echo "Preparando login/LoginLoop.sh..."
    dos2unix ./login/LoginLoop.sh 2>/dev/null
    chmod +x ./login/LoginLoop.sh

    # Verificar se o script está executável
    if [ -x "./login/LoginLoop.sh" ]; then
        echo "Executando login/LoginLoop.sh..."
        ./login/LoginLoop.sh
    else
        echo "Erro: Não foi possível conceder permissão de execução ao login/LoginLoop.sh."
        exit 1
    fi
else
    echo "Erro: O arquivo login/LoginLoop.sh não foi encontrado!"
    exit 1
fi
