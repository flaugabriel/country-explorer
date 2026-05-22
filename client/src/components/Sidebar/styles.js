import styled from "styled-components";
import { NavLink } from "react-router-dom";

export const Sidebar = styled.aside`
  position: fixed;
  top: 0;
  left: 0;
  width: 230px;
  height: 100vh;
  background-color: #1a1d2e;
  display: flex;
  flex-direction: column;
  padding: 24px 16px;
  z-index: 1000;
`;

export const Brand = styled.div`
  color: white;
  font-size: 15px;
  font-weight: 700;
  letter-spacing: 0.4px;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  margin-bottom: 8px;
`;

export const UserInfo = styled.div`
  color: #a0aec0;
  font-size: 12px;
  margin-bottom: 28px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
`;

export const Nav = styled.nav`
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
`;

export const NavItem = styled(NavLink)`
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 14px;
  border-radius: 6px;
  color: #a0aec0;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  transition: background-color 0.15s, color 0.15s;

  &:hover {
    background-color: rgba(255, 255, 255, 0.08);
    color: white;
  }

  &.active {
    background-color: #046ee5;
    color: white;
  }
`;

export const LogoutButton = styled.button`
  background: none;
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 6px;
  color: #a0aec0;
  padding: 10px 14px;
  font-size: 14px;
  cursor: pointer;
  text-align: left;
  transition: background-color 0.15s, color 0.15s, border-color 0.15s;

  &:hover {
    background-color: rgba(220, 38, 38, 0.15);
    border-color: rgba(220, 38, 38, 0.5);
    color: #f87171;
  }
`;

export const ContentWrapper = styled.div`
  margin-left: 230px;
  min-height: 100vh;
  background-color: #f0f2f5;
`;
