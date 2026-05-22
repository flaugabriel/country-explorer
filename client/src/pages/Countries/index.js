import React, { useEffect, useState, useCallback } from 'react';
import { notify } from '../../utils/notify';
import { fetchCountry, fetchSearchHistory } from '../../operations/countries';
import { countryPtToEn } from '../../utils/countryPtToEn';
import CountryCard from '../../components/CountryCard';
import SearchInput from '../../components/SearchInput';
import SearchHistoryList from '../../components/SearchHistoryList';
import './styles.css';

const Countries = () => {
  const authorization = localStorage.getItem('authorization');
  const [country, setCountry]   = useState(null);
  const [history, setHistory]   = useState([]);
  const [loading, setLoading]   = useState(false);

  const loadHistory = useCallback(() => {
    fetchSearchHistory(authorization)
      .then((res) => setHistory(res.data?.data || []))
      .catch(() => {});
  }, [authorization]);

  useEffect(() => {
    loadHistory();
  }, [loadHistory]);

  const handleSearch = (name) => {
    setLoading(true);
    setCountry(null);

    // Tradução PT->EN se necessário
    const nameLower = name.trim().toLowerCase();
    const translated = countryPtToEn[nameLower] || name;

    fetchCountry(authorization, translated)
      .then((res) => {
        setCountry(res.data?.data);
        loadHistory();
      })
      .catch((err) => {
        const status = err.response?.status;
        if (status === 404) {
          notify.error(`País "${name}" não encontrado.`);
        } else if (status === 503) {
          notify.error('Serviço externo indisponível. Tente novamente em instantes.');
        } else {
          notify.error('Erro inesperado. Tente novamente.');
        }
      })
      .finally(() => setLoading(false));
  };

  return (
    <main className="countries-page">
      <div className="container">
        <div className="countries-header">
          <h2 className="countries-title">Country Explorer</h2>
          <p className="countries-subtitle">
            Pesquise um país e visualize informações detalhadas
          </p>
        </div>

        <SearchInput onSearch={handleSearch} loading={loading} />

        <SearchHistoryList history={history} onSelect={handleSearch} />

        {loading && (
          <div className="text-center mt-5">
            <div className="spinner-border text-primary" role="status" />
          </div>
        )}

        {!loading && <CountryCard country={country} />}
      </div>
    </main>
  );
};

export default Countries;
