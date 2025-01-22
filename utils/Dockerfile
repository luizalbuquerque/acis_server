# Usar a imagem base do MariaDB
FROM yobasystems/alpine-mariadb:latest

# Definir a variável de ambiente para a senha do root
ENV MYSQL_ROOT_PASSWORD=root

# Instalar o cliente mysql e o nano (opcional, para edição)
RUN apk add --no-cache mysql-client nano

# Copiar os arquivos SQL para o diretório correto dentro do container
COPY sql/ /tmp/sql/

# Copiar o script de inicialização para o container
COPY init-db.sh /docker-entrypoint-initdb.d/

# Dar permissão de execução ao script
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Configuração do container
CMD ["/usr/bin/mariadbd"]
