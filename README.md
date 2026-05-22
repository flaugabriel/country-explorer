# Country Explorer

Aplicação full-stack que combina **autenticação segura** (MFA/TOTP, bloqueio por tentativas, recuperação de senha) com **exploração de países** via REST Countries API.

> Documentação técnica: [ia/docs/README.md](ia/docs/README.md)

---

## Índice rápido

| Seção | Link |
|-------|------|
| Visão geral | [ia/docs/overview.md](ia/docs/overview.md) |
| Setup | [ia/docs/getting-started.md](ia/docs/getting-started.md) |
| Banco de dados | [ia/docs/database.md](ia/docs/database.md) |
| Endpoints da API | [ia/docs/endpoints.md](ia/docs/endpoints.md) |
| Autenticação & segurança | [ia/docs/authentication.md](ia/docs/authentication.md) |
| Frontend | [ia/docs/frontend.md](ia/docs/frontend.md) |

---

## Pré-requisitos

- Docker e Docker Compose instalados

> O comando pode ser `docker-compose` (v1) ou `docker compose` (v2). Este projeto usa `docker compose`.

## Setup

```shell
docker compose up --build -d
docker compose run --rm api rails db:drop db:create db:migrate
```

Acesse:

- **Frontend:** http://localhost:3000
- **API:** http://localhost:3030
- **MailCatcher:** http://localhost:1080

## Testes

```shell
docker compose run --rm -e RAILS_ENV=test api bundle exec rspec
```

Cobertura: `api/coverage/index.html` após rodar os testes.

---

Para contratos JSON, fluxos de MFA e endpoints de países, consulte a [documentação em ia/docs](ia/docs/README.md).
