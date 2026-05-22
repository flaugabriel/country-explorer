
import axios from 'axios';

const API_BASE = process.env.REACT_APP_API_URL
  ? `${process.env.REACT_APP_API_URL}/api`
  : '/api';

export const fetchComments = (countryCode, authHeaders) =>
  axios.get(`${API_BASE}/countries/${countryCode}/comments`, { headers: authHeaders });

export const postComment = (countryCode, content, authHeaders) =>
  axios.post(`${API_BASE}/countries/${countryCode}/comments`, { comment: { content, country_code: countryCode } }, { headers: authHeaders });

export const likeComment = (commentId, like, authHeaders) =>
  axios.post(`${API_BASE}/comments/${commentId}/like`, { like }, { headers: authHeaders });
