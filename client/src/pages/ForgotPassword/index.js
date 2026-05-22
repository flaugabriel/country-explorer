import React, { useState } from "react";
import * as C from "./styles";
import Input from "../../components/Input";
import Button from "../../components/Button";
import { forgotPassword } from "../../operations/auth";
import { notify, notifyApiError, formatApiMessage } from "../../utils/notify";

const ForgotPassword = () => {
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = () => {
    if (!email) {
      setError("Preencha todos os campos");
    }else{
      forgotPassword(email).then((response) => {
        if (response.data.status === 404) {
          notify.error(formatApiMessage(response.data) || 'E-mail não encontrado.');
        }else{
          notify.success(`Enviamos um link de recuperação para ${email}.`);
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
        <C.Strong>Insira seu email para enviarmos um link de redefinição</C.Strong>
        <Input 
          type="text"
          placeholder="example@example.com"
          value={email}
          onChange={(e) => [setEmail(e.target.value), setError("")]}
        />
        <C.labelError>{error}</C.labelError>
        
        <Button Text="Entrar" onClick={handleSubmit} />
      </C.Content>
    </C.Container>
    </>
  );
};

export default ForgotPassword;