import React, { useEffect, useState } from "react";
import * as C from "./styles";
import { Link } from "react-router-dom";
import { showUnlock } from "../../operations/auth";
import { useLocation } from "react-router-dom";
import { notify, notifyApiError, formatApiMessage } from "../../utils/notify";

const UnlockShow = () => {
  const location = useLocation();
  const [check, setCheck] = useState(true)
  var unlock_token = location.search.slice(1).split('&').map(kv => kv.split('='))[0][1]

  const showUnlockUser = () => {
    showUnlock(unlock_token).then((response) => {
      if (response.data.status === 404) {
        notify.error(formatApiMessage(response.data) || 'Não foi possível desbloquear a conta.');
      }else{
        notify.success('Conta desbloqueada! Você já pode fazer login.');
        setCheck(true)
      }
    }).catch((error) => {
      if (error.response?.status === 500) {
        notify.error('Erro interno. Tente novamente mais tarde.');
      } else {
        notifyApiError(error, 'Não foi possível desbloquear a conta.');
      }
    })
  };

  useEffect(() => {
    if (check) {
      showUnlockUser()
    }
  },);

  return (
    <main className="flex-shrink-0">
      <div className="text-center">
        <div className="container margin-top">
          <div className="card">
            <div className="card-body">
              <h1>Login desbloqueado.</h1>
              <C.Strong>
                <Link to="/">&nbsp;Vá para a pagina de login.</Link>
              </C.Strong>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
};

export default UnlockShow;