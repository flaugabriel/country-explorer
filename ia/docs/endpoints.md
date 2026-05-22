# API — Referência de Endpoints

Base URL da API: `http://localhost:3030`

---

## Autenticação (DeviseTokenAuth)

### Cadastro de Usuário

```
POST /api/auth
```

**Body:**
```json
{
  "email": "user@example.com",
  "password": "Senha@Forte123",
  "password_confirmation": "Senha@Forte123"
}
```

**Resposta 200:**
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "provider": "email",
    "uid": "user@example.com",
    "allow_password_change": false,
    "email": "user@example.com",
    "created_at": "2023-05-22T10:48:54.580-04:00",
    "updated_at": "2023-05-22T10:48:54.639-04:00"
  }
}
```

---

### Login

```
POST /api/auth/sign_in
```

**Body:**
```json
{
  "email": "user@example.com",
  "password": "Senha@Forte123"
}
```

**Resposta 200:**
```json
{
  "data": {
    "email": "user@example.com",
    "provider": "email",
    "uid": "user@example.com",
    "id": 1,
    "allow_password_change": false
  }
}
```

> O token de autenticação é retornado nos **headers** de resposta:
> - `Authorization` — Bearer token
> - `access-token`
> - `client`
> - `uid`
> - `expiry`
> - `token-type`

---

## Conta do Usuário (requer autenticação)

> Todos os endpoints abaixo exigem o header:  
> `Authorization: Bearer <token>`

### Perfil do Usuário

```
GET /api/myaccount/profile
```

**Resposta 200:**
```json
{
  "data": { /* atributos do usuário */ },
  "mfa_status": false
}
```

---

### Atualizar Senha

```
PUT /api/myaccount/profile
```

**Body:**
```json
{
  "user": {
    "password": "NovaSenha@123",
    "password_confirmation": "NovaSenha@123"
  }
}
```

**Resposta 200:**
```json
{
  "message": "Senha atualizado, realize o login novamente!"
}
```

**Resposta 422:**
```json
{
  "error": "mensagem de validação"
}
```

---

### Obter QR Code para MFA

```
GET /api/myaccount/open_qrcode_mfa
```

**Resposta 200:**
```json
{
  "qrcode": "https://storage.host/rails/active_storage/blobs/.../temp.png"
}
```

---

## MFA — Multi-Factor Authentication

### Ativar MFA

```
POST /users/enable_multi_factor_authentication
```

**Body:**
```json
{
  "id": 1,
  "otp_code_token": "123456"
}
```

**Resposta 200:**
```json
{ "messager": "MFA ativado!" }
```

**Resposta 422:**
```json
{ "messager": "Token invalido!" }
```

---

### Desativar MFA

```
POST /users/disable_multi_factor_authentication
```

**Body:**
```json
{
  "id": 1
}
```

> **Comportamento atual:** o endpoint **não valida** `otp_code_token` — desativa o MFA imediatamente para o usuário autenticado. O frontend ainda envia o token por compatibilidade. Veja [authentication.md](authentication.md).

**Resposta 200:**
```json
{ "messager": "MFA Desativado" }
```

---

### Login com MFA

```
POST /users/mfa
```

> Requer autenticação prévia via `/api/auth/sign_in`.

**Body:**
```json
{
  "otp_code_token": "123456"
}
```

**Resposta 200:**
```json
{ "messager": "Bem vindo!" }
```

**Resposta 505 (token inválido):**
```json
{ "messager": "Suas credenciais são invalidas." }
```

---

## Recuperação de Senha

### Solicitar Reset

```
POST /password/forgot
```

**Body:**
```json
{
  "email": "user@example.com"
}
```

**Resposta 200:**
```json
{ "status": "ok" }
```

**Resposta 404:**
```json
{ "error": ["Email address not found. Please check and try again."] }
```

---

### Redefinir Senha

```
POST /password/reset
```

**Body:**
```json
{
  "email": "user@example.com",
  "token": "<reset_token>",
  "password": "NovaSenha@Forte123"
}
```

**Resposta 200:**
```json
{ "status": "ok" }
```

**Resposta 404 (link expirado ou inválido):**
```json
{ "error": "Link not valid or expired. Try generating a new link." }
```

> O token expira em **4 horas** após o envio do e-mail.

---

## Desbloqueio de Conta

```
GET /unlock/show?unlock_token=<email_do_usuario>
```

> O parâmetro se chama `unlock_token`, mas a implementação busca o usuário pelo **e-mail** (`User.find_by(email: params[:unlock_token])`). Veja ressalvas em [authentication.md](authentication.md).

**Resposta 200:**
```json
{ "status": "ok" }
```

---

## Country Explorer (requer autenticação)

> Header: `Authorization: Bearer <token>`

### Buscar país

```
GET /api/countries/:name
```

`:name` é o termo de busca (ex.: `brazil`, `portugal`). A API consulta REST Countries em `/v3.1/name/{name}` com campos reduzidos.

**Resposta 200:**
```json
{
  "data": {
    "name": "Brazil",
    "official_name": "Federative Republic of Brazil",
    "flag": "https://flagcdn.com/w320/br.png",
    "flag_alt": "The flag of Brazil...",
    "capital": "Brasília",
    "population": 212559409,
    "currencies": ["Brazilian real (BRL)"],
    "languages": ["Portuguese"],
    "continent": "South America",
    "timezones": ["UTC-05:00", "UTC-04:00", "UTC-03:00", "UTC-02:00"]
  }
}
```

**Resposta 404:**
```json
{ "error": "Country not found" }
```

**Resposta 503** (timeout ou indisponibilidade externa):
```json
{ "error": "External service unavailable, please try again later" }
```

**Resposta 500:**
```json
{ "error": "Unexpected error" }
```

> Respostas bem-sucedidas são cacheadas por **1 hora** (`Rails.cache`). Um registro em `search_histories` é criado após cada busca com sucesso.

---

### Histórico de buscas

```
GET /api/search_histories
```

**Resposta 200:**
```json
{
  "data": [
    {
      "id": 1,
      "country_name": "Brazil",
      "created_at": "2023-07-12T15:30:00.000Z"
    }
  ]
}
```

Retorna até **20** países distintos (mais recentes primeiro), deduplicados por nome.

---

## Tabela Resumida de Endpoints

| Método | Caminho | Auth | Descrição |
|--------|---------|------|-----------|
| POST | `/api/auth` | Não | Cadastro de usuário |
| POST | `/api/auth/sign_in` | Não | Login |
| DELETE | `/api/auth/sign_out` | Sim | Logout |
| GET | `/api/myaccount/profile` | Sim | Perfil e status MFA |
| PUT | `/api/myaccount/profile` | Sim | Atualizar senha |
| GET | `/api/myaccount/open_qrcode_mfa` | Sim | QR Code para MFA |
| POST | `/users/enable_multi_factor_authentication` | Sim | Ativar MFA |
| POST | `/users/disable_multi_factor_authentication` | Sim | Desativar MFA |
| POST | `/users/mfa` | Sim | Autenticar com token OTP |
| POST | `/password/forgot` | Não | Solicitar reset de senha |
| POST | `/password/reset` | Não | Redefinir senha via token |
| GET | `/unlock/show` | Não | Desbloquear conta |
| GET | `/api/countries/:name` | Sim | Buscar país (REST Countries) |
| GET | `/api/search_histories` | Sim | Histórico de buscas do usuário |
