import React, { useEffect, useState } from "react";
import Input from "../../components/Input";
import Button from "../../components/Button";
import * as C from "./styles";
import { Link, useNavigate } from "react-router-dom";
import { signin } from '../../operations/auth';
import { notify, notifyApiError, formatApiMessage } from '../../utils/notify';

const Signin = () => {
  const navigate = useNavigate();
  const [signed, setSigned] = useState(false)
  const [email, setEmail] = useState("");
  const [senha, setSenha] = useState("");
  const [error, setError] = useState("");

  const handleLogin = () => {
    if (!email | !senha) {
      setError("Preencha todos os campos");
    }else{
      signin(email, senha).then((response) => {
        if (response.data.status === 404) {
          notify.error(formatApiMessage(response.data) || 'Credenciais inválidas.');
        }else{
          localStorage.removeItem("authorization");
          localStorage.setItem("authorization", response.headers['authorization']);
          if (response.data.data.otp_module === 'enabled') {
            navigate('/mfa')
          }else{
            setSigned(true)
          }
        }
      }).catch((error) => {
        if (error.response?.status === 500) {
          notify.error('Erro interno. Tente novamente mais tarde.');
        } else {
          notifyApiError(error, 'Não foi possível entrar. Verifique e-mail e senha.');
        }
      });
    }
  };

  useEffect(() => {
    if (signed) {
      navigate('/home')
    }else{
      navigate('/')
    }
  },[signed]);

  return (
    <C.Container>
      <C.Label>LOGIN</C.Label>
      <C.Content>
        <Input
          type="email"
          placeholder="Digite seu E-mail"
          value={email}
          onChange={(e) => [setEmail(e.target.value), setError("")]}
        />
        <Input
          type="password"
          placeholder="Digite sua Senha"
          value={senha}
          onChange={(e) => [setSenha(e.target.value), setError("")]}
        />
        <C.labelError>{error}</C.labelError>
        <Button Text="Entrar" onClick={handleLogin} />
        <C.LabelSignup>
        Esqueceu sua senha?
          <C.Strong>
            <Link to="/forgot_password">&nbsp;recupere aqui.</Link>
          </C.Strong>
        </C.LabelSignup>
        <C.LabelSignup>
          Não tem uma conta?
          <C.Strong>
            <Link to="/signup">&nbsp;Registre-se</Link>
          </C.Strong>
        </C.LabelSignup>
      </C.Content>
    </C.Container>
  );
};

export default Signin;