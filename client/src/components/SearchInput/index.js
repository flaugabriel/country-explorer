import React, { useState } from 'react';

const SearchInput = ({ onSearch, loading }) => {
  const [value, setValue] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    const trimmed = value.trim();
    if (trimmed) onSearch(trimmed);
  };

  return (
    <form onSubmit={handleSubmit} className="d-flex gap-2">
      <input
        type="text"
        className="form-control form-control-lg"
        placeholder="Digite o nome do país em português ou inglês"
        value={value}
        onChange={(e) => setValue(e.target.value)}
        disabled={loading}
      />
      <button
        type="submit"
        className="btn btn-primary btn-lg"
        disabled={loading || !value.trim()}
        style={{ whiteSpace: 'nowrap' }}
      >
        {loading ? (
          <>
            <span className="spinner-border spinner-border-sm me-2" role="status" />
            Buscando...
          </>
        ) : (
          'Buscar'
        )}
      </button>
    </form>
  );
};

export default SearchInput;
