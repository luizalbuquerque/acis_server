#!/bin/bash

# Variáveis de ambiente com valores padrão
DB_HOST=${DB_HOST:-mysql}
DB_PORT=${DB_PORT:-3306}
DB_USER=${DB_USER:-root}
DB_PASS=${DB_PASS:-123@123}
DB_NAME=${DB_NAME:-aCis}

#### ETAPA 1: Iniciar MySQL ####
echo "#### ETAPA 1: Iniciando MySQL ####"

# Função para aguardar a inicialização do MySQL
wait_for_mysql() {
    echo "Aguardando MySQL inicializar..."
    until mysqladmin ping -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" --silent; do
        sleep 2
    done
    echo "MySQL está pronto!"
}

# Iniciar o MySQL
echo "Iniciando MySQL..."
/usr/bin/mysqld_safe --datadir=/var/lib/mysql &

# Aguardar inicialização do MySQL
sleep 10
wait_for_mysql

# Verificar se o MySQL foi iniciado corretamente
if mysqladmin ping -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" --silent; then
    echo "MySQL iniciado com sucesso."
else
    echo "Erro ao iniciar o MySQL. Verifique os logs para mais detalhes."
    exit 1
fi

#### ETAPA 2: Conceder permissões ao usuário MySQL ####
echo "#### ETAPA 2: Concedendo permissões ao usuário MySQL ####"
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Verificar o status da execução do comando
if [ $? -eq 0 ]; then
    echo "Permissões aplicadas com sucesso."
else
    echo "Erro ao conceder permissões. Verifique a configuração do MySQL."
    exit 1
fi

#### ETAPA 3: Criar o banco de dados ####
echo "#### ETAPA 3: Criando banco de dados $DB_NAME ####"
create_database() {
    # Verificar se o banco já existe
    echo "Verificando a existência do banco de dados $DB_NAME..."
    if mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;" 2>/dev/null; then
        echo "Banco de dados $DB_NAME já existe. Pulando criação."
    else
        echo "Banco de dados $DB_NAME não encontrado. Criando banco de dados..."
        mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE $DB_NAME;"
        if [ $? -eq 0 ]; then
            echo "Banco de dados $DB_NAME criado com sucesso."
        else
            echo "Erro ao criar o banco de dados $DB_NAME. Verifique os logs para mais detalhes."
            exit 1
        fi
    fi
}

# Chamar a função para criar o banco de dados
create_database

#### ETAPA 4: Importar todos os arquivos SQL ####
echo "#### ETAPA 4: Importando todos os arquivos SQL ####"
import_all_sql() {
    echo "Aplicando todos os scripts SQL..."
    for sql_file in /app/sql/*.sql; do
        echo "Aplicando script $sql_file..."
        mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" $DB_NAME < "$sql_file"
        if [ $? -ne 0 ]; then
            echo "Erro ao aplicar o script $sql_file. Verifique o arquivo e a sintaxe do script."
            exit 1
        else
            echo "Scripts SQL - $sql_file aplicados com sucesso."
        fi
    done
}

# Executar a importação dos arquivos SQL
import_all_sql

#### ETAPA 5: Iniciar Login Server ####
echo "#### ETAPA 5: Iniciando Login Server ####"
if [ -f /app/login/LoginServer_loop.sh ]; then
    echo "Aplicando permissões ao script LoginServer_loop.sh..."
    chmod 777 /app/login/LoginServer_loop.sh
    echo "Iniciando Login Server..."
    nohup /app/login/LoginServer_loop.sh > /app/login/loginserver.log 2>&1 &
    # Verificar se o Login Server está rodando e mostrar logs
    tail -f /app/login/loginserver.log
else
    echo "Erro: LoginServer_loop.sh não encontrado. Verifique o caminho."
    exit 1
fi

#### ETAPA 6: Iniciar Game Server ####
echo "#### ETAPA 6: Iniciando Game Server ####"
if [ -f /app/gameserver/GameServer_loop.sh ]; then
    echo "Aplicando permissões ao script GameServer_loop.sh..."
    chmod 777 /app/gameserver/GameServer_loop.sh
    echo "Iniciando Game Server..."
    nohup /app/gameserver/GameServer_loop.sh > /app/gameserver/game_server.log 2>&1 &
    # Adicionar um loop para garantir que ele continue rodando
    while true; do
        sleep 30
        if ! ps aux | grep '[G]ameServer' > /dev/null; then
            echo "Game Server caiu. Reiniciando..."
            nohup /app/gameserver/GameServer_loop.sh > /app/gameserver/game_server.log 2>&1 &
        fi
    done
else
    echo "Erro: GameServer_loop.sh não encontrado. Verifique o caminho."
    exit 1
fi

# Aguardar 75 segundos antes de finalizar (ou ajustar conforme necessário)
sleep 75
