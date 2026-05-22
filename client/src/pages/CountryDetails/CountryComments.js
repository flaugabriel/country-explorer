import React, { useEffect, useState } from 'react';

import { fetchComments, postComment, likeComment } from '../../operations/comments';
import { updateAuthHeadersFromResponse } from '../../utils/authHeaders';

const CountryComments = ({ countryCode, user }) => {
  const [comments, setComments] = useState([]);
  const [newComment, setNewComment] = useState('');
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    console.log('[DEBUG] Render CountryComments with countryCode:', countryCode);
    if (!countryCode || !/^\d{3}$/.test(countryCode)) return;
    setLoading(true);
    const tokenHeaders = getAuthHeaders();
    console.log('[CountryComments] GET comments', { countryCode, tokenHeaders });
    fetchComments(countryCode, tokenHeaders)
      .then(res => {
        console.log('[CountryComments] GET response', res);
        setComments(Array.isArray(res.data) ? res.data : []);
      })
      .catch((err) => {
        console.error('[CountryComments] GET error', err);
        if (err.response && err.response.status === 401) {
          setError('Faça login para ver os comentários.');
        }
        setComments([]);
      })
      .finally(() => setLoading(false));
  }, [countryCode]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!newComment.trim() || !countryCode || !/^\d{3}$/.test(countryCode)) return;
    setSubmitting(true);
    setError(null);
    console.log('[DEBUG] POST comment countryCode:', countryCode);
    console.log('[CountryComments] POST comment', { newComment, countryCode });
    try {
      const tokenHeaders = getAuthHeaders();
      const postRes = await postComment(countryCode, newComment, tokenHeaders);
      updateAuthHeadersFromResponse(postRes);
      console.log('[CountryComments] POST response', postRes);
      // Busca novamente todos os comentários após criar
      const res = await fetchComments(countryCode, tokenHeaders);
      updateAuthHeadersFromResponse(res);
      console.log('[CountryComments] GET after POST', res);
      setComments(Array.isArray(res.data) ? res.data : []);
      setNewComment('');
    } catch (err) {
      if (err.response && err.response.data && err.response.data.errors) {
        setError('Erro: ' + err.response.data.errors.join(', '));
      } else if (err.response && err.response.status === 401) {
        setError('Erro: não autenticado. Faça login.');
      } else {
        setError('Erro ao comentar.');
      }
    } finally {
      setSubmitting(false);
    }
  };

  const handleLike = async (commentId, like) => {
    if (!countryCode) return;
    try {
      const tokenHeaders = getAuthHeaders();
      await likeComment(commentId, like, tokenHeaders);
      // Atualiza comentários após curtir/descurtir
      const res = await fetchComments(countryCode, tokenHeaders);
      setComments(Array.isArray(res.data) ? res.data : []);
    } catch (err) {
      setError('Erro ao curtir/descurtir. Faça login.');
    }
  };

  function getAuthHeaders() {
    // Pega tokens do localStorage (devise_token_auth)
    const accessToken = localStorage.getItem('access-token');
    const client = localStorage.getItem('client');
    const uid = localStorage.getItem('uid');
    const tokenType = localStorage.getItem('token-type') || 'Bearer';
    return {
      'access-token': accessToken,
      client,
      uid,
      'token-type': tokenType,
      Authorization: `${tokenType} ${accessToken}`,
    };
  }

  return (
    <div className="mt-5">
      <h4 className="mb-3">Comentários</h4>
      <form className="mb-4" onSubmit={handleSubmit} style={{ display: 'flex', gap: 8 }}>
        <input
          type="text"
          className="form-control"
          placeholder="Escreva um comentário público..."
          style={{ maxWidth: 400 }}
          value={newComment}
          onChange={e => setNewComment(e.target.value)}
          disabled={submitting}
        />
        <button className="btn btn-primary" type="submit" disabled={submitting || !newComment.trim()}>Comentar</button>
      </form>
      {error && <div className="alert alert-danger py-2">{error}</div>}
      <div style={{ maxWidth: 600 }}>
        {loading ? <div>Carregando comentários...</div> :
          comments.length === 0 ? <div className="text-muted">Nenhum comentário ainda.</div> :
          comments.map(comment => (
            <div key={comment.id} className="mb-3 p-3 bg-light rounded border">
              <div className="mb-1" style={{ fontSize: 13, color: '#666' }}>
                <b>{comment.user_email}</b> <span style={{ fontSize: 11 }}>({new Date(comment.created_at).toLocaleString()})</span>
              </div>
              <div className="mb-2">{comment.content}</div>
              <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
                <button className="btn btn-sm btn-outline-success" type="button" onClick={() => handleLike(comment.id, true)}>
                  👍 {comment.likes_count}
                </button>
                <button className="btn btn-sm btn-outline-danger" type="button" onClick={() => handleLike(comment.id, false)}>
                  👎 {comment.dislikes_count}
                </button>
              </div>
            </div>
          ))}
      </div>
    </div>
  );
};

export default CountryComments;
