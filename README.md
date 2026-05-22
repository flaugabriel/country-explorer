# Access Security

Sistema de autenticação segura full-stack com suporte a MFA/TOTP, bloqueio por tentativas, recuperação de senha e expiração de sessão.

> 📚 **Documentação técnica completa:** [ia/docs/README.md](ia/docs/README.md)

---

## Índice rápido

| Seção | Link |
|-------|------|
| Arquitetura & visão geral | [ia/docs/README.md](ia/docs/README.md) |
| Banco de dados | [ia/docs/database.md](ia/docs/database.md) |
| Endpoints da API | [ia/docs/endpoints.md](ia/docs/endpoints.md) |

---

## Pré-requisitos

- Docker e Docker Compose instalados

> **Atenção:** dependendo da versão do Docker Compose, o comando pode ser `docker-compose` (v1) ou `docker compose` (v2). Este projeto usa `docker compose`.

## Setup

Na raiz do projeto, execute os comandos abaixo em ordem:

```shell
# 1. Builda as imagens e sobe os containers
docker compose up --build -d

# 2. Configura o banco de dados
docker compose run --rm api rails db:drop db:create db:migrate
```

Acesse:
- **Frontend:** http://localhost:3000
- **API (status):** http://localhost:3030
- **Mailcatcher (emails de teste):** http://localhost:1080
  - Todos os emails enviados em desenvolvimento (ex: recuperação de senha) podem ser visualizados acessando esse endereço no navegador.

## Testes

```shell
docker compose run --rm api rspec
```

## Cobertura de código (SimpleCov)

Após rodar os testes, abra `api/coverage/index.html` no navegador para visualizar o relatório de cobertura.

---

> Para detalhes de endpoints, contratos JSON e fluxos de autenticação, consulte a [documentação técnica](ia/docs/README.md). 🚀


