#!/bin/bash

# Certifique-se de que o script será executado no shell correto
set -e  # Faz o script parar em caso de erro

# Garantir permissão de execução no arquivo setup_data.sh
if [ -f "./setup_data.sh" ]; then
    echo "Adicionando permissão de execução ao setup_data.sh..."
    chmod +x ./setup_data.sh
    
    # Verificar se a permissão foi aplicada corretamente
    if [ -x "./setup_data.sh" ]; then
        echo "Permissão de execução concedida com sucesso ao setup_data.sh!"
        echo "Executando ./setup_data.sh..."
        ./setup_data.sh
    else
        echo "Erro: Não foi possível conceder permissão de execução ao setup_data.sh."
        exit 1
    fi
else
    echo "Erro: O arquivo ./setup_data.sh não foi encontrado!"
    exit 1
fi

echo "Processo concluído com sucesso!"
