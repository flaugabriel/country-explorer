import React from 'react';

const DetailItem = ({ label, value }) => (
  <div className="col-12 col-md-6">
    <div className="p-2 bg-light rounded border">
      <span className="fw-semibold text-secondary">{label}: </span>
      <span>{value || '—'}</span>
    </div>
  </div>
);

export default DetailItem;
