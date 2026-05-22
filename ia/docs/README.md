# Access Security — Documentação Técnica

Documentação de arquitetura e engenharia de software do projeto **Access Security** (anteriormente `country-explorer`), uma aplicação full-stack com foco em mecanismos de acesso seguro.

---

## Índice

| Documento | Descrição |
|-----------|-----------|
| [Visão Geral da Arquitetura](architecture/overview.md) | Diagrama de alto nível e decisões de design |
| [Banco de Dados](architecture/database.md) | Esquema, entidades e migrações |
| [API — Arquitetura](api/overview.md) | Estrutura interna da API Rails |
| [API — Endpoints](api/endpoints.md) | Referência completa de rotas e contratos |
| [Autenticação & Segurança](security/authentication.md) | Fluxos de auth, MFA, lockout e tokens |
| [Frontend](frontend/overview.md) | Estrutura React, rotas e operações HTTP |
| [Configuração & Setup](setup/getting-started.md) | Como instalar e executar localmente |

---

## Resumo do Projeto

Sistema de autenticação segura com os seguintes mecanismos:

- **Senha segura** com regras de complexidade rígidas
- **Expiração de sessão** controlada via token JWT
- **Bloqueio por tentativas** após exceder o limite de falhas
- **Duplo fator de autenticação (MFA/TOTP)** via QR Code
- **Recuperação de senha** com link por e-mail com expiração
- **Desbloqueio de conta** por e-mail

## Stack Tecnológico

| Camada | Tecnologia |
|--------|-----------|
| Backend | Ruby 3.0.2 / Rails 7.0.4.3 (API mode) |
| Frontend | React 18.2.0 |
| Banco de Dados | PostgreSQL (stable) |
| Containerização | Docker 24.0.0 / Docker Compose 1.29.2 |
| Autenticação | Devise + DeviseTokenAuth + devise-two-factor |
| Comunicação | REST JSON API |
| E-mail de desenvolvimento | MailCatcher |
