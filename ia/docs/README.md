# Country Explorer — Documentação Técnica

Documentação de arquitetura e engenharia do repositório **country-explorer**: aplicação full-stack que combina **autenticação segura** (Country Explorer) com **exploração de países** via API externa.

> A documentação fica em `ia/docs/` (não `ai/docs`).

---

## Índice

| Documento | Descrição |
|-----------|-----------|
| [Visão Geral da Arquitetura](overview.md) | Diagramas, camadas e decisões de design |
| [Banco de Dados](database.md) | Esquema, entidades e migrações |
| [API — Endpoints](endpoints.md) | Referência de rotas e contratos JSON |
| [Autenticação & Segurança](authentication.md) | Fluxos de auth, MFA, lockout, tokens e ressalvas |
| [Frontend](frontend.md) | Estrutura React, rotas e operações HTTP |
| [Configuração & Setup](getting-started.md) | Instalação e execução local com Docker |

---

## Resumo do Projeto

### Autenticação e acesso (Country Explorer)

- **Senha segura** com regras de complexidade no cadastro
- **Expiração de sessão** via Devise `:timeoutable` (5 minutos de inatividade)
- **Bloqueio por tentativas** após 5 falhas de login
- **Duplo fator (MFA/TOTP)** com QR Code via ActiveStorage
- **Recuperação de senha** por e-mail (token válido por 4 horas)
- **Desbloqueio de conta** via endpoint dedicado

### Country Explorer

- **Busca de países** autenticada (`GET /api/countries/:name`) integrada com [REST Countries](https://restcountries.com)
- **Histórico de buscas** por usuário (`GET /api/search_histories`)
- **Cache** de respostas externas (1 hora) no Rails.cache
- **UI** em `/countries` com cards, busca e histórico clicável

---

## Stack Tecnológico

| Camada | Tecnologia |
|--------|-----------|
| Backend | Ruby 3.0.2 / Rails 7.0.4.3 (API mode) |
| Frontend | React 18.2.0 |
| Banco de Dados | PostgreSQL |
| API externa | REST Countries (`restcountries.com`) |
| HTTP client | Faraday 2.x |
| Containerização | Docker / Docker Compose |
| Autenticação | Devise + DeviseTokenAuth + devise-two-factor |
| Comunicação | REST JSON |
| E-mail (dev) | MailCatcher |
