import axios from 'axios';

const urlBase = 'http://localhost:3030/api/';

// ccn3 deve ser string de 3 dígitos
export const fetchCountry = (authorization, ccn3) =>
  axios({
    url: urlBase + `countries/${encodeURIComponent(ccn3)}`,
    method: 'GET',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      Authorization: `${authorization}`,
    },
  });

export const fetchSearchHistory = (authorization) =>
  axios({
    url: urlBase + 'search_histories',
    method: 'GET',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      Authorization: `${authorization}`,
    },
  });
