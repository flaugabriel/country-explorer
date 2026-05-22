import React, { useState, useEffect } from "react";
import * as C from "./styles";
import Input from "../../../components/Input";
import Button from "../../../components/Button";
import { session, enableMfa, disableMfa, openQrcodeMfa} from "../../../operations/auth";
import { notify, notifyApiError } from "../../../utils/notify";

const MfaSettings = () => {
  const authorization = localStorage.getItem("authorization");
  const [user, setUser] = useState();
  const [qrcodeMfa, setQrcodeMfa] = useState();
  const [status, setStatus] = useState()
  const [token, setToken] = useState("");
  const [error, setError] = useState("");

  const getProfile = () => {
    session(authorization).then((items) => {
      if (items.data !== undefined) {
        setStatus(items.data.mfa_status)
        setUser(items.data.data)
      }else{
        console.log(items);
      }
    }).catch(error => {
      console.log(error);
    });
  }

  const showQrCode = () => {
    openQrcodeMfa(authorization).then((items) => {
      if (items.data !== undefined) {
        setQrcodeMfa(items.data.qrcode);
      }else{
        console.log(items.data.messager);
      }
    }).catch(error => {
      console.log(error);
    });
  }

  const handleMfaEnable = () => {
    enableMfa(authorization, user.id, token).then((items) => {
      if (items.data !== undefined) {
        setUser(items.data.data)
        notify.success('MFA ativado com sucesso!');
        getProfile();
      }else{
        console.log(items);
      }
    }).catch((error) => {
      notifyApiError(error, 'Token inválido. Tente novamente.');
    });
  };

  const handleMfaDisable = () => {
    disableMfa(authorization, user.id, token).then((items) => {
      if (items.data !== undefined) {
        setUser(items.data.data)
        notify.success('MFA desativado.');
        getProfile();
      }else{
        console.log(items);
      }
    }).catch((error) => {
      notifyApiError(error, 'Não foi possível desativar o MFA.');
    });
  };

  useEffect(() => {
    if (authorization && user === undefined) {
      getProfile();
    }
  },);

  return (
    <>
      <C.Container>
      <C.Label>MFA Painel</C.Label>
      <C.Content>
      {
      status ?
        <Button Text="Desativa MFA" onClick={handleMfaDisable} />
        :
        <>
          <div className="text-center">
            {
              qrcodeMfa ? 
            <>

              <img src={qrcodeMfa} alt="SVG" width={250}/>
                  <Input
                  type="number"
                  placeholder="XXX XXX"
                  value={token}
                  onChange={(e) => [setToken(e.target.value), setError("")]}
                />
            <C.Strong>Insira o token de autenticação gerado pelo aplicativo</C.Strong>

            <Button Text="Salvar" onClick={handleMfaEnable} />
            </>

            : null
            }
            </div>
            {
              qrcodeMfa ? 
              null
            :
            <Button Text="Ativa MFA ?" onClick={showQrCode} />

            }
        </>
        }
      </C.Content>
    </C.Container>
    </>
  );
};

export default MfaSettings;