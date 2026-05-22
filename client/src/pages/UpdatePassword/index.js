import React, { useState } from "react";
import * as C from "./styles";
import Input from "../../components/Input";
import Button from "../../components/Button";
import { resetPassword } from "../../operations/auth";
import { useLocation, useNavigate } from "react-router-dom";
import { notify, notifyApiError, formatApiMessage } from "../../utils/notify";

const UpdatePassword = () => {
  const navigate = useNavigate();
  const location = useLocation();
  let token = location.search.slice(1).split('&').map(kv => kv.split('='))[0][1]
  var email = location.search.slice(1).split('&').map(kv => kv.split('='))[1][1]

  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = () => {
    if (!password) {
      setError("Preencha todos os campos");
    }else{
      resetPassword(email, password, token).then((response) => {
        if (response.data.status === 404) {
          notify.error(response.data.errors?.[0] || formatApiMessage(response.data) || 'Link inválido ou expirado.');
        }else{
          notify.success('Senha redefinida com sucesso! Faça login com a nova senha.');
          navigate('/')
        }
      }).catch((error) => {
        notifyApiError(error, 'Serviço indisponível. Tente novamente mais tarde.');
      });
    }
  };

  return (
    <>
       <C.Container>
      <C.Label>Recupere sua senha</C.Label>
      <C.Content>
        <C.Strong>Informe a nova senha</C.Strong>
        <Input
          type="password"
          placeholder="Digite sua Senha"
          value={password}
          onChange={(e) => [setPassword(e.target.value), setError("")]}
        />
        <C.labelError>{error}</C.labelError>
        
        <Button Text="Atualizar" onClick={handleSubmit} />
      </C.Content>
    </C.Container>
    </>
  );
};

export default UpdatePassword;