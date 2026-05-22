import axios from 'axios';
import { updateAuthHeadersFromResponse } from '../utils/authHeaders';

const urlBase= 'http://localhost:3030/api/';
const urlBasePublic= 'http://localhost:3030/';

export const signin = async (email, password) => {
  const response = await axios({
    url: urlBase + 'auth/sign_in',
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    data: { email: email, password: password },
  });
  updateAuthHeadersFromResponse(response);
  return response;
}

export const signup = (email, password, password_confirmation) => 
  axios({
    url: urlBase + 'auth',
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    data: { email: email, password: password, password_confirmation: password_confirmation },
  })

export const session = (authorization) => 
  axios({
    url: urlBase + 'myaccount/profile',
    method: "GET",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      'Authorization': `${authorization}`
    }
  })

export const passwordUpdate = (authorization, password, password_confirmation) =>
  axios({
    url: urlBase + 'myaccount/profile',
    method: "PUT",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      'Authorization': `${authorization}`
    },
    data: { user: { password: password, password_confirmation: password_confirmation }},
  })

export const forgotPassword = (email) =>
  axios({
    url: urlBasePublic + 'password/forgot',
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json"
    },
    data: { email: email},
  })

export const resetPassword = (email, password, token) =>
  axios({
    url: urlBasePublic + 'password/reset',
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json"
    },
    data: { email: email, token: token, password: password},
  })

export const showUnlock = (unlock_token) =>
  axios({
    url: urlBasePublic + 'unlock/show?unlock_token='+unlock_token,
    method: "get",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json"
    }
  })

export const enableMfa = (authorization, id, otp_code_token) =>
  axios({
    url: urlBasePublic + 'users/enable_multi_factor_authentication',
    method: "post",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      'Authorization': `${authorization}`
    },
    data: {id: id, otp_code_token: otp_code_token}
  })

export const disableMfa = (authorization, id, otp_code_token) =>
  axios({
    url: urlBasePublic + 'users/disable_multi_factor_authentication',
    method: "post",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      'Authorization': `${authorization}`
    },
    data: {id: id, otp_code_token: otp_code_token}
  })

export const openQrcodeMfa = (authorization) =>
  axios({
    url: urlBase + 'myaccount/open_qrcode_mfa',
    method: "get",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      'Authorization': `${authorization}`
    }
  })

export const signinMfa = (email, authorization, token) => 
  axios({
    url: urlBasePublic + 'users/mfa',
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      'Authorization': `${authorization}`
    },
    data: { email: email, otp_code_token: token},
  })

export const signout = () => {
  localStorage.removeItem("authorization");
};

export default [signup, signout, signin, session, passwordUpdate, resetPassword, forgotPassword, enableMfa, disableMfa, openQrcodeMfa];
