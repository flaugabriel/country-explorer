import React, { useEffect, useState, useCallback } from 'react';
import { toast } from 'react-toastify';
import { fetchCountry, fetchSearchHistory } from '../../operations/countries';
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

    fetchCountry(authorization, name)
      .then((res) => {
        setCountry(res.data?.data);
        loadHistory();
      })
      .catch((err) => {
        const status = err.response?.status;
        if (status === 404) {
          toast.error(`País "${name}" não encontrado.`);
        } else if (status === 503) {
          toast.error('Serviço externo indisponível. Tente novamente em instantes.');
        } else {
          toast.error('Erro inesperado. Tente novamente.');
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
