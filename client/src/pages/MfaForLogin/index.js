import React, { useEffect, useState } from "react";
import * as C from "../User/styles";
import Input from "../../components/Input";
import Button from "../../components/Button";
import { signinMfa } from "../../operations/auth";
import { useNavigate } from "react-router-dom";
import { notify, notifyApiError, formatApiMessage } from '../../utils/notify';

const MfaForLogin = () => {
  const navigate = useNavigate();
  const [token, setToken] = useState("");
  const [error, setError] = useState("");
  const email = localStorage.getItem("email");
  const authorization = localStorage.getItem("authorization");

  const handleLogin = () => {
    if (!token) {
      setError("Token não informado!");
    }else{
      signinMfa(email, authorization, token).then((response) => {
        if (response.data.status === 404) {
          notify.error(formatApiMessage(response.data) || 'Token não informado.');
        }else{
          if (response.data) {
            localStorage.setItem("mfa", true);
            notify.success('Bem-vindo!');
            navigate('/home')
          }else{
            notify.error('Token inválido.');
          }
        }
      }).catch((error) => {
        if (error.response?.status === 500) {
          notify.error('Erro interno. Tente novamente mais tarde.');
        } else {
          notifyApiError(error, 'Credenciais inválidas.');
        }
      });
    }
  };

  return (
    <>
      <C.Container>
      <C.Label>Login via MFA</C.Label>
      <C.Content>
        <C.Strong>Insira o token de autenticação gerado pelo aplicativo</C.Strong>
        <Input 
          type="text"
          placeholder="XXX XXX"
          value={token}
          onChange={(e) => [setToken(e.target.value), setError("")]}
        />
        <C.labelError>{error}</C.labelError>
        
        <Button Text="Entrar" onClick={handleLogin} />
      </C.Content>
    </C.Container>
    </>
  );
};

export default MfaForLogin;