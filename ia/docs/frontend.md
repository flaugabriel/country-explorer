# Frontend (React)

SPA em **React 18.2** com **react-router-dom v6**, **axios** e **react-toastify**.

---

## Estrutura

```
client/src/
├── App.js
├── routes/index.js
├── operations/
│   ├── auth.js
│   └── countries.js
├── pages/
├── components/
└── styles/global.js
```

---

## Rotas

Definidas em `client/src/routes/index.js`:

| Rota | Componente | Proteção |
|------|------------|----------|
| `/` | Signin | Pública |
| `/signup` | Signup | Pública |
| `/forgot_password` | ForgotPassword | Pública |
| `/update_password` | UpdatePassword | Pública |
| `/unlock/show` | UnlockShow | Pública |
| `/mfa` | MfaForLogin | Semi-pública (requer token parcial) |
| `/home` | Home | `Private` |
| `/countries` | Countries | `Private` |
| `/password` | User/Password | `Private` |
| `/settings/mfa` | User/MfaSettings | `Private` |

### Guard `Private`

- Verifica `localStorage.authorization`.
- Se ausente, renderiza `Signin`.
- Se presente, renderiza `Navbar` + página solicitada.
- Carrega perfil via `GET /api/myaccount/profile` quando aplicável.
- **Não** força conclusão do fluxo MFA antes de acessar `/countries` — apenas presença do token.

---

## Operações HTTP

### `operations/auth.js`

| Função | Método | Endpoint |
|--------|--------|----------|
| `signin` | POST | `/api/auth/sign_in` |
| `signup` | POST | `/api/auth` |
| `session` | GET | `/api/myaccount/profile` |
| `passwordUpdate` | PUT | `/api/myaccount/profile` |
| `forgotPassword` | POST | `/password/forgot` |
| `resetPassword` | POST | `/password/reset` |
| `showUnlock` | GET | `/unlock/show` |
| `openQrcodeMfa` | GET | `/api/myaccount/open_qrcode_mfa` |
| `enableMfa` / `disableMfa` | POST | `/users/enable_*` / `disable_*` |
| `signinMfa` | POST | `/users/mfa` |
| `signout` | — | Limpa `localStorage` apenas |

Base URL atual: `http://localhost:3030` (hardcoded).

### `operations/countries.js`

| Função | Método | Endpoint |
|--------|--------|----------|
| `fetchCountry` | GET | `/api/countries/:name` |
| `fetchSearchHistory` | GET | `/api/search_histories` |

---

## Country Explorer (`/countries`)

Página principal pós-autenticação para exploração de países:

1. **SearchInput** — dispara busca por nome.
2. **CountryCard** — exibe bandeira, capital, população, moedas, idiomas, etc.
3. **SearchHistoryList** — últimas buscas; clique repete a pesquisa.

Tratamento de erros com toasts:

| Status | Mensagem (PT) |
|--------|----------------|
| 404 | País não encontrado |
| 503 | Serviço externo indisponível |
| Outros | Erro inesperado |

---

## Estado de sessão (`localStorage`)

| Chave | Uso |
|-------|-----|
| `authorization` | Header Bearer para API |
| `mfa_status` | Se MFA está ativo na conta |
| `mfa` | Flag temporária durante fluxo MFA pós-login |

---

## Variáveis de ambiente

O `docker-compose.yml` define `REACT_APP_API_URL: http://localhost:3030`, mas **`auth.js` e `countries.js` não a utilizam** ainda. Para ambientes diferentes do localhost, centralizar a base URL em `process.env.REACT_APP_API_URL`.

---

## Dependências relevantes

- `axios` — cliente HTTP
- `react-router-dom` — roteamento
- `react-toastify` — notificações
- `styled-components` — estilos em algumas páginas
- `bootstrap` — layout em páginas como Countries
