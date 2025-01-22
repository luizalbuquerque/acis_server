@echo off
echo =============================
echo Passo 1 - Copiar scripts SQL
echo =============================
docker cp ./sql acis_database:/tmp/sql

echo =============================
echo Passo 2 - Verificar se arquivos foram copiados
echo =============================
docker exec acis_database ls -l tmp/sql

echo =============================
echo Passo 3 - Criar o banco de dados se não existir
echo =============================
mysql -u root -proot -h 127.0.0.1 -P 3333 -e "CREATE DATABASE IF NOT EXISTS acis; USE acis;"

echo =============================
echo Passo 4 - Validar se o banco foi criado
echo =============================
mysql -u root -proot -h 127.0.0.1 -P 3333 -e "SHOW DATABASES;"

echo =============================
echo Passo 5 - Executar scripts SQL externamente
echo =============================
docker exec acis_database bash -c "for file in /tmp/sql/*.sql; do if [ -f \"$file\" ]; then echo \"Importando $file...\"; mysql -u root -proot acis < \"$file\"; else echo \"Nenhum arquivo encontrado em /tmp/sql/*.sql\"; fi; done"

echo =============================
echo Passo 6 - Validar quantas tabelas foram geradas no acis
echo =============================
mysql -u root -proot -h 127.0.0.1 -P 3333 -e "USE acis; SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'acis';"

echo =============================
echo Finalizado!
echo =============================
pause
