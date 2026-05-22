# Visão Geral da Arquitetura

## Estilo Arquitetural

O projeto adota uma arquitetura **cliente-servidor desacoplada** (SPA + REST API), onde:

- O **frontend React** é responsável pela interface e estado de sessão local.
- O **backend Rails** expõe uma API JSON stateless com autenticação via token.
- O **PostgreSQL** persiste todos os dados de usuário.
- O **Docker Compose** orquestra todos os serviços.

---

## Diagrama de Componentes

```mermaid
graph TD
    Browser["Navegador (React SPA)\n:3000"]
    API["Rails API\n:3030"]
    DB["PostgreSQL\n:5432"]
    Mail["MailCatcher\n:1080 (SMTP :1025)"]
    Storage["ActiveStorage\n(armazenamento de blobs)"]

    Browser -- "HTTP/JSON + Bearer Token" --> API
    API -- "ActiveRecord" --> DB
    API -- "SMTP" --> Mail
    API -- "blob (QR Code PNG)" --> Storage
```

---

## Diagrama de Implantação (Docker Compose)

```mermaid
graph LR
    subgraph docker-compose
        db["db\n(postgres)"]
        api["api\n(rails)"]
        client["client\n(react)"]
        mailcatcher["mailcatcher"]
    end

    client -- "depends_on" --> api
    api -- "depends_on" --> db
    api -- "SMTP :1025" --> mailcatcher
```

| Serviço | Imagem | Porta exposta |
|---------|--------|---------------|
| `db` | `postgres` | 5432 |
| `api` | Dockerfile local (Ruby) | 3030 |
| `client` | Dockerfile local (Node) | 3000 |
| `mailcatcher` | `yappabe/mailcatcher` | 1025 (SMTP), 1080 (UI) |

---

## Camadas da Aplicação

### Backend (Rails API)

```
api/
├── app/
│   ├── controllers/       # Controladores REST
│   │   ├── api/v1/        # Recursos versionados (namespace :api)
│   │   └── users/         # Ações Devise estendidas (MFA, Sessions)
│   ├── models/            # ActiveRecord + Devise modules
│   ├── services/          # Objetos de serviço (ex: QrcodeCreateService)
│   ├── mailers/           # ActionMailer (forgot password, lock notification)
│   └── serializers/       # ActiveModelSerializers (v0.10)
├── config/
│   ├── routes.rb          # Roteamento central
│   └── initializers/      # Devise, DeviseTokenAuth, CORS
├── db/
│   ├── schema.rb          # Estado atual do banco
│   └── migrate/           # Histórico de migrações
└── lib/
    └── api_constraints.rb # Roteamento por versão via Accept header
```

### Frontend (React SPA)

```
client/src/
├── App.js                 # Ponto de entrada, aplica rotas e estilos globais
├── routes/index.js        # Definição de rotas (react-router-dom v6)
├── operations/auth.js     # Todas as chamadas HTTP (axios)
├── pages/                 # Telas da aplicação
│   ├── Signin/
│   ├── Signup/
│   ├── Home/
│   ├── ForgotPassword/
│   ├── UpdatePassword/
│   ├── MfaForLogin/
│   ├── UnlockShow/
│   └── User/              # Password, MfaSettings
└── components/            # UI reutilizável (Button, Input, Navbar)
```

---

## Decisões de Design

| Decisão | Justificativa |
|---------|--------------|
| Rails em modo API | Elimina overhead de views/assets; responde somente JSON |
| DeviseTokenAuth | Autenticação stateless via Bearer Token, compatível com SPA |
| Versionamento de API via Accept header | Permite evolução da API sem quebrar clientes existentes |
| MFA via TOTP (RFC 6238) | Padrão amplamente suportado por apps autenticadores |
| ActiveStorage para QR Code | Gera URL temporária do blob sem persistência desnecessária |
| MailCatcher em dev | Captura e-mails sem envio real durante o desenvolvimento |
