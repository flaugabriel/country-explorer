# Configuração & Setup

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) e Docker Compose (v2: `docker compose`)

---

## Subir o ambiente

Na raiz do repositório:

```shell
# 1. Build e containers em background
docker compose up --build -d

# 2. Banco de dados
docker compose run --rm api rails db:drop db:create db:migrate
```

---

## URLs locais

| Serviço | URL |
|---------|-----|
| Frontend | http://localhost:3000 |
| API (status) | http://localhost:3030 |
| MailCatcher (UI) | http://localhost:1080 |

E-mails de desenvolvimento (reset de senha, bloqueio, etc.) aparecem no MailCatcher.

---

## Testes

```shell
docker compose run --rm -e RAILS_ENV=test api bundle exec rspec
```

> SimpleCov exige **100%** de cobertura de linha. O serviço `api` no Compose usa `RAILS_ENV=production` por padrão — use `RAILS_ENV=test` ao rodar os testes.

Cobertura (SimpleCov): após os testes, abra `api/coverage/index.html`.

---

## Serviços Docker

| Serviço | Função |
|---------|--------|
| `db` | PostgreSQL |
| `api` | Rails API (`bash start.sh`, porta 3030) |
| `client` | React dev server (porta 3000) |
| `mailcatcher` | SMTP fake + UI web |

### Variáveis da API (`docker-compose.yml`)

```yaml
POSTGRES_USER: postgres
POSTGRES_PASSWORD: postgres
POSTGRES_HOST: db
RAILS_ENV: production          # ambiente local via Compose
SMTP_HOST: mailcatcher
SMTP_PORT: "1025"
SECRET_KEY_BASE: <valor fixo>  # trocar em ambientes reais
```

> `RAILS_ENV=production` no Compose local pode afetar logging e recarregamento. Para desenvolvimento iterativo sem Docker, use `development` localmente.

---

## Testar em production (Docker)

A infra atual já sobe com `RAILS_ENV=production` no serviço `api` e o client com build estático (`npm run build` + `serve`).

```shell
docker compose up --build -d
```

Aguarde a API subir (logs: `Listening on http://0.0.0.0:3030` e `Environment: production`).

| Serviço | URL | Verificação |
|---------|-----|-------------|
| API health | http://localhost:3030 | JSON com `"environment":"production"` |
| Frontend | http://localhost:3000 | Build React servido em modo estático |
| MailCatcher | http://localhost:1080 | E-mails de reset/senha |

**Testes manuais sugeridos no navegador:**

1. Cadastro em `/signup` (senha forte: maiúscula, minúscula, número e especial).
2. Login em `/` → `/home` ou `/countries`.
3. Buscar um país em `/countries`.
4. MFA em `/settings/mfa` (opcional).
5. Recuperação de senha em `/forgot_password` → conferir e-mail no MailCatcher.

**Testes via API (curl):**

```shell
curl http://localhost:3030/
curl -X POST http://localhost:3030/api/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{"email":"seu@email.com","password":"SuaSenha@123"}'
```

> Os testes automatizados (`rspec`) usam `RAILS_ENV=test` — não confundir com este modo production.

---

## Fluxo sugerido para testar

1. Acesse http://localhost:3000 e crie uma conta (`/signup`).
2. Faça login — se MFA estiver ativo, complete em `/mfa`.
3. Acesse **Country Explorer** em `/countries` e busque um país (ex.: `Brazil`).
4. Verifique o histórico de buscas na mesma página.
5. Em **Configurações MFA** (`/settings/mfa`), ative/desative o segundo fator.
6. Teste recuperação de senha e visualize o e-mail no MailCatcher.

---

## Documentação relacionada

- [Endpoints](endpoints.md)
- [Autenticação](authentication.md)
- [Arquitetura](overview.md)
