// Utilitário para Devise Token Auth: atualiza os tokens do localStorage a partir dos headers da resposta
export function updateAuthHeadersFromResponse(response) {
  if (!response || !response.headers) return;
  const headers = response.headers;
  if (headers['access-token']) localStorage.setItem('access-token', headers['access-token']);
  if (headers['client']) localStorage.setItem('client', headers['client']);
  if (headers['uid']) localStorage.setItem('uid', headers['uid']);
  if (headers['token-type']) localStorage.setItem('token-type', headers['token-type']);
}
