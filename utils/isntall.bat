@echo off
REM ############################################
REM ## Configurações do banco de dados ##
REM ############################################

set mysqlBinPath=C:\Program Files\MySQL\MySQL Server 5.5\bin
set sqlPath=C:\Users\Luiz de Albuquerque\Downloads\ACIS 409 in test\acis_409\acis_public-master\aCis_datapack\sql

REM Configure os detalhes do banco de dados aqui:
set DBHOST=localhost
set DBUSER=root
set DBPASS=123@123
set DBNAME=acis409

REM ############################################
REM Validar o caminho do MySQL e diretório SQL
if not exist "%mysqlBinPath%\mysql.exe" (
    echo [ERRO] MySQL executável não encontrado em %mysqlBinPath%.
    pause
    exit /b
)

if not exist "%sqlPath%" (
    echo [ERRO] Diretório SQL não encontrado: %sqlPath%.
    pause
    exit /b
)

REM ############################################
REM Executar todos os arquivos .sql no diretório

echo Iniciando execução de arquivos SQL no diretório %sqlPath%.
pause
for %%f in ("%sqlPath%\*.sql") do (
    echo Executando arquivo: %%~nxf
    "%mysqlBinPath%\mysql.exe" -h %DBHOST% -u %DBUSER% --password=%DBPASS% %DBNAME% < "%%f"
    if errorlevel 1 (
        echo [ERRO] Falha ao executar o arquivo %%~nxf. Verifique o conteúdo do arquivo.
        pause
        exit /b
    )
    echo [SUCESSO] Arquivo %%~nxf executado com sucesso.
)

echo Todos os arquivos SQL foram executados com sucesso.
pause
