import React, { useState, useEffect} from "react";
import Input from "../../components/Input";
import Button from "../../components/Button";
import * as C from "./styles";
import { Link } from "react-router-dom";
import { signup } from '../../operations/auth';
import { signout } from '../../operations/auth';
import { useNavigate } from "react-router-dom";
import { notify, notifyApiError } from '../../utils/notify';

const Signup = () => {
  const navigate = useNavigate();
  const [signed, setSigned] = useState(false)
  const [iSup, setIsup] = useState(false)
  const [email, setEmail] = useState("");
  const [emailConf, setEmailConf] = useState("");
  const [password, setPassword] = useState("");
  const [password_confirmation, setPasswordConfirmation] = useState("");
  const [error, setError] = useState("");

  const handleSignup = () => {
    if (!email | !emailConf | !password | !password_confirmation) {
      setError("Preencha todos os campos");
    } else if (email !== emailConf) {
      setError("Os e-mails não são iguais");
    }else{
      signup(email, password, password_confirmation).then((response) => {
        if (response.data.status === 404) {
          notify.error('Serviço indisponível. Tente novamente mais tarde.');
          signout()
        }else{
          localStorage.removeItem("authorization");
          localStorage.setItem("authorization", response.headers['authorization']);
          notify.success('Cadastro realizado com sucesso!');
          setSigned(true)
          setIsup(true)
        }
      }).catch((error) => {
        notifyApiError(error, 'Não foi possível concluir o cadastro.');
        signout()
      });
    }
  };

  useEffect(() => {
    if (signed && iSup) {
      navigate('/home')
    }if(iSup){
      navigate('/home')
    }
  },[ signed ]);

  return (
    <C.Container>
      <C.Label>REGISTRE-SE</C.Label>
      <C.Content>
        <Input
          type="email"
          placeholder="Digite seu E-mail"
          value={email}
          onChange={(e) => [setEmail(e.target.value), setError("")]}
        />
        <Input
          type="email"
          placeholder="Confirme seu E-mail"
          value={emailConf}
          onChange={(e) => [setEmailConf(e.target.value), setError("")]}
        />
        <Input
          type="password"
          placeholder="Digite sua Senha"
          value={password}
          onChange={(e) => [setPassword(e.target.value), setError("")]}
        />
        <Input
          type="password"
          placeholder="Confirme sua senha"
          value={password_confirmation}
          onChange={(e) => [setPasswordConfirmation(e.target.value), setError("")]}
        />
        <C.labelError>{error}</C.labelError>
        <Button Text="Inscrever-se" onClick={handleSignup} />
        <C.LabelSignin>
          Já tem uma conta?
          <C.Strong>
            <Link to="/">&nbsp;Entre</Link>
          </C.Strong>
        </C.LabelSignin>
      </C.Content>
    </C.Container>
  );
};

export default Signup;