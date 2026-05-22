import React from "react";
import * as C from "./styles";
import { signout } from "../../operations/auth";
import { useNavigate } from "react-router-dom";

const Sidebar = ({ children }) => {
  const navigate = useNavigate();
  const email = localStorage.getItem("email");
  const username = email ? email.split("@")[0] : "";

  const handleSignout = () => {
    signout();
    navigate("/");
  };

  return (
    <>
      <C.Sidebar>
        <C.Brand>Country Explorer</C.Brand>
        <C.UserInfo>Olá, {username}</C.UserInfo>
        <C.Nav>
          <C.NavItem to="/countries">🌍 Países</C.NavItem>
          <C.NavItem to="/password">🔒 Senha</C.NavItem>
          <C.NavItem to="/settings/mfa">🔐 MFA</C.NavItem>
        </C.Nav>
        <C.LogoutButton onClick={handleSignout}>⬅ Sair</C.LogoutButton>
      </C.Sidebar>
      <C.ContentWrapper>{children}</C.ContentWrapper>
    </>
  );
};

export default Sidebar;
