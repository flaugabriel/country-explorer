import React from 'react';

const SearchHistoryList = ({ history, onSelect }) => {
  if (!history || history.length === 0) return null;

  return (
    <div className="mt-4">
      <h6 className="text-muted mb-2">Pesquisas recentes</h6>
      <div className="d-flex flex-wrap gap-2">
        {history.map((item) => (
          <button
            key={item.id}
            type="button"
            className="btn btn-outline-secondary btn-sm"
            onClick={() => onSelect(item.country_name)}
            title={new Date(item.created_at).toLocaleString('pt-BR')}
          >
            {item.country_name}
          </button>
        ))}
      </div>
    </div>
  );
};

export default SearchHistoryList;
