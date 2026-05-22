import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { fetchCountry } from '../../operations/countries';
import CountryCard from '../../components/CountryCard';
import { notify } from '../../utils/notify';
import DetailItem from './DetailItem';

const CountryDetails = () => {
  const { name } = useParams();
  const authorization = localStorage.getItem('authorization');
  const [country, setCountry] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetchCountry(authorization, name)
      .then((res) => setCountry(res.data?.data))
      .catch(() => notify.error('Não foi possível carregar detalhes do país.'))
      .finally(() => setLoading(false));
  }, [authorization, name]);

  return (
    <main className="countries-page">
      <div className="container">
        {loading ? (
          <div className="text-center mt-5">
            <div className="spinner-border text-primary" role="status" />
          </div>
        ) : (
          <>
            <h2 className="countries-title mb-4">Detalhes do País</h2>
            <CountryCard country={country} />
            <div className="row g-3 mt-4">
              {country?.area && (
                <DetailItem label="Área (km²)" value={country.area.toLocaleString('pt-BR')} />
              )}
              {(country?.iso2 || country?.iso3 || country?.iso_numeric) && (
                <DetailItem label="Código ISO" value={[
                  country.iso2 && `Alpha2: ${country.iso2}`,
                  country.iso3 && `Alpha3: ${country.iso3}`,
                  country.iso_numeric && `Numérico: ${country.iso_numeric}`
                ].filter(Boolean).join(' | ')} />
              )}
              {country?.calling_code && (
                <DetailItem label="Código de chamada" value={country.calling_code} />
              )}
              {country?.tld && (
                <DetailItem label="Domínio de internet" value={country.tld} />
              )}
              {country?.borders && country.borders.length > 0 && (
                <DetailItem label="Países vizinhos" value={country.borders.join(', ')} />
              )}
              {(country?.latitude && country?.longitude) && (
                <DetailItem label="Localização" value={<a href={`https://www.google.com/maps/search/?api=1&query=${country.latitude},${country.longitude}`} target="_blank" rel="noopener noreferrer">Ver no mapa</a>} />
              )}
              {country?.government && (
                <DetailItem label="Governo" value={country.government} />
              )}
              {country?.head_of_state && (
                <DetailItem label="Chefe de Estado" value={country.head_of_state} />
              )}
              {country?.independence_date && (
                <DetailItem label="Data de independência" value={country.independence_date} />
              )}
              {country?.gdp && (
                <DetailItem label="PIB" value={country.gdp} />
              )}
              {country?.life_expectancy && (
                <DetailItem label="Expectativa de vida" value={country.life_expectancy} />
              )}
              {country?.literacy_rate && (
                <DetailItem label="Taxa de alfabetização" value={country.literacy_rate} />
              )}
              {country?.main_religion && (
                <DetailItem label="Religião principal" value={country.main_religion} />
              )}
              {country?.currencies_details && (
                <DetailItem label="Moeda(s) detalhada(s)" value={country.currencies_details} />
              )}
              {country?.flag_hd && (
                <DetailItem label="Bandeira HD" value={<img src={country.flag_hd} alt="Bandeira HD" style={{maxWidth:'120px',border:'1px solid #eee'}} />} />
              )}
              {country?.anthem && (
                <DetailItem label="Hino nacional" value={<a href={country.anthem} target="_blank" rel="noopener noreferrer">Ouvir</a>} />
              )}
              {country?.wikipedia && (
                <DetailItem label="Wikipedia" value={<a href={country.wikipedia} target="_blank" rel="noopener noreferrer">Ver página</a>} />
              )}
              {country?.cia_factbook && (
                <DetailItem label="CIA World Factbook" value={<a href={country.cia_factbook} target="_blank" rel="noopener noreferrer">Ver página</a>} />
              )}
            </div>
          </>
        )}
      </div>
    </main>
  );
};

export default CountryDetails;
