
# Projeto ACIS 384 v.alb - Updated

## 🐳 Docker Commands Documentation

### 🛠️ Montar Containers (Dockerfile + Compose)
Para construir e iniciar os containers:
```bash
docker-compose up --build -d
```

### 🐳 Listar Containers Ativos
Para visualizar os containers ativos:
```bash
docker ps --format "{{.Names}} | {{.Status}} | {{.Ports}}" | column -s "|" -t | sort
```

### 🚫 Parar e Remover Containers
Para parar e remover os containers:
```bash
docker stop $(docker ps -q) && docker rm $(docker ps -aq)
```

### 💻 Acessar o Container MySQL Diretamente
Para acessar o MySQL diretamente no container:
```bash
docker exec -it acis384_database mysql -u root -p123@123 aCis
```

### 📜 Logs do Container Server
Para visualizar os logs do container server:
```bash
docker logs server_acis384
```

### 🗂️ Logs do Container MySQL
Para visualizar os logs do MySQL:
```bash
docker logs acis384_database
```

### 🧹 Remover Todas as Imagens Docker
Para remover todas as imagens:
```bash
docker rmi $(docker images -aq) --force
```

### 🧼 Limpar Volumes e Redes
Para limpar volumes não utilizados:
```bash
docker volume prune -f
```
Para limpar redes não utilizadas:
```bash
docker network prune -f
```

### 🔍 Outros Comandos Úteis
- **Listar imagens disponíveis:**
  ```bash
  docker images
  ```
- **Conectar ao container MySQL genérico:**
  ```bash
  docker exec -it acis-mariadb mysql -u root -p
  ```

---

## 🔐 Configuração de SSH para GitHub

### 🔍 Verificar Existência de Chaves SSH
```bash
ls ~/.ssh/id_*
```

### ➕ Adicionar a Chave ao Agente SSH
Adicione sua chave ao `ssh-agent`:
```bash
ssh-add ~/.ssh/id_ed25519
```

### ✅ Conferir Chaves no Agente
Veja as chaves carregadas:
```bash
ssh-add -l
```

### 🧪 Testar o Git
Realize um push de teste:
```bash
git push origin nome_branch
```

### 🔄 Configurar o `ssh-agent` no Windows
Configure o `ssh-agent` para iniciar automaticamente:
```bash
Get-Service ssh-agent | Set-Service -StartupType Automatic
```

---

## 🐧 Comandos para Ubuntu 24

### 🗑️ Remover Pastas e Arquivos Permanentemente
```bash
rm -rf /opt/*
```

### 🚀 Maven Commands
- Limpar e construir o projeto sem executar testes:
  ```bash
  mvn clean install -DskipTests
  ```
- Forçar o Maven a limpar o repositório e atualizar dependências:
  ```bash
  mvn clean install -U
  ```

### 🛠️ Comandos de Serviço MySQL no PowerShell
- **Parar o serviço MySQL:**
  ```bash
  Stop-Service -Name MySQL
  ```
- **Verificar o status do MySQL:**
  ```bash
  Get-Service -Name MySQL
  ```
- **Iniciar o serviço MySQL:**
  ```bash
  Start-Service -Name MySQL
  ```
