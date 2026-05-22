import React, { Fragment, useEffect, useState, } from "react";
import { session } from '../operations/auth';
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Home from "../pages/Home";
import Signin from "../pages/Signin";
import Signup from "../pages/Signup";
import Password from "../pages/User/Password";
import Sidebar from "../components/Sidebar";
import MfaForLogin from "../pages/MfaForLogin";
import MfaSettings from "../pages/User/MfaSettings";
import ForgotPassword from "../pages/ForgotPassword";
import UpdatePassword from "../pages/UpdatePassword";
import UnlockShow from "../pages/UnlockShow";
import Countries from "../pages/Countries";
import CountryDetails from "../pages/CountryDetails";
import { useNavigate } from "react-router-dom";

const Private = ({ Item }) => {
  const navigate = useNavigate();
  const authorization = localStorage.getItem("authorization");
  const mfa_status = localStorage.getItem("mfa_status");
  const [user, setUser] = useState();
  const mfa = localStorage.getItem("mfa");

  const getProfile = () => {
    session(authorization).then((items) => {
      if (items.data !== undefined) {
        setUser(items.data.data);
        if (items.data.data && items.data.data.email) {
          localStorage.setItem('email', items.data.data.email);
        }
      }
    }).catch(error => {
      console.log(error);
    });
  }

  useEffect(() => {
    if (authorization && user === undefined && !mfa) {
      getProfile();
    }
  },);

  var signed = false;
  if (authorization) {
    signed = true
  }

  return(
    signed ? 
      <Sidebar>
        <Item />
      </Sidebar>
    :
      <Signin />
  )
};

const RoutesApp = () => {

  return (
    <>
    <BrowserRouter>
      <Fragment>
        <Routes>
          <Route exact path="/home" element={<Private Item={Countries} />} />
          <Route exact path="/countries" element={<Private Item={Countries} />} />
          <Route path="/countries/:name" element={<Private Item={CountryDetails} />} />
          <Route exact path="/password" element={<Private Item={Password} />} />
          <Route exact path="/settings/mfa" element={<Private Item={MfaSettings} />} />
          <Route path="/mfa" element={<MfaForLogin />} />
          <Route path="/update_password" element={<UpdatePassword />} />
          <Route path="/forgot_password" element={<ForgotPassword />} />
          <Route path="/unlock/show" element={<UnlockShow />} />
          <Route path="/" element={<Signin />} />
          <Route exact path="/signup" element={<Signup />} />
          <Route path="*" element={<Signin />} />
        </Routes>
      </Fragment>
    </BrowserRouter>
    </>
  );
};

export default RoutesApp;