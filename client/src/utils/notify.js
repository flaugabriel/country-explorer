import { toast } from 'react-toastify';

const defaultOptions = {
  position: 'top-right',
  autoClose: 4000,
};

export const notify = {
  success: (message) => toast.success(message, defaultOptions),
  error: (message) => toast.error(message, defaultOptions),
  info: (message) => toast.info(message, defaultOptions),
  warn: (message) => toast.warn(message, defaultOptions),
};

export function formatApiMessage(data) {
  if (!data) return null;
  if (typeof data === 'string') return data;
  if (data.messager) return data.messager;
  if (data.message) return data.message;

  if (data.error) {
    return Array.isArray(data.error) ? data.error.join(', ') : String(data.error);
  }

  if (data.errors) {
    if (Array.isArray(data.errors)) return data.errors.join(', ');
    if (data.errors.full_messages) return data.errors.full_messages.join(', ');
    if (typeof data.errors === 'object') {
      return Object.values(data.errors).flat().join(', ');
    }
    return String(data.errors);
  }

  return null;
}

export function notifyApiError(error, fallback = 'Não foi possível completar a operação. Tente novamente.') {
  if (!error?.response) {
    notify.error(fallback);
    return;
  }

  const message = formatApiMessage(error.response.data);
  notify.error(message || fallback);
}
