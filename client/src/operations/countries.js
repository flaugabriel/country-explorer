import axios from 'axios';

const urlBase = 'http://localhost:3030/api/';

export const fetchCountry = (authorization, name) =>
  axios({
    url: urlBase + `countries/${encodeURIComponent(name)}`,
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
