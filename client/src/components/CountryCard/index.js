import React from 'react';
import { useNavigate } from 'react-router-dom';

const CountryCard = ({ country }) => {
  const navigate = useNavigate();
  if (!country) return null;

  const handleClick = () => {
    if (country.name) {
      navigate(`/countries/${encodeURIComponent(country.name)}`);
    }
  }

  return (
    <div className="card shadow-sm mt-4">
      <div className="card-body">
        <div className="d-flex align-items-center gap-3 mb-3">
          {country.flag && (
            <img
              src={country.flag}
              alt={country.flag_alt || `Flag of ${country.name}`}
              style={{ height: '60px', borderRadius: '4px', boxShadow: '0 1px 4px rgba(0,0,0,.2)' }}
            />
          )}
          <div>
            <h4 className="mb-0" style={{ cursor: 'pointer', color: '#046ee5', textDecoration: 'underline' }} onClick={handleClick} title="Ver detalhes">
              {country.name}
            </h4>
            {country.official_name && country.official_name !== country.name && (
              <small className="text-muted">{country.official_name}</small>
            )}
          </div>
        </div>

        <div className="row g-2">
          <InfoItem label="Capital" value={country.capital} />
          <InfoItem label="Continente" value={country.continent} />
          <InfoItem
            label="População"
            value={country.population?.toLocaleString('pt-BR')}
          />
          <InfoItem
            label="Moeda(s)"
            value={Array.isArray(country.currencies) ? country.currencies.join(', ') : '—'}
          />
          <InfoItem
            label="Idioma(s)"
            value={Array.isArray(country.languages) ? country.languages.join(', ') : '—'}
          />
          <InfoItem
            label="Fuso(s) horário(s)"
            value={Array.isArray(country.timezones) ? country.timezones.join(', ') : '—'}
          />
        </div>
      </div>
    </div>
  );
};

const InfoItem = ({ label, value }) => (
  <div className="col-12 col-sm-6">
    <div className="p-2 bg-light rounded">
      <span className="fw-semibold text-secondary">{label}: </span>
      <span>{value || '—'}</span>
    </div>
  </div>
);

export default CountryCard;
