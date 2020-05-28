import React, { useState, useEffect } from "react";
import { Link, useHistory } from "react-router-dom";
import { LinkContainer } from "react-router-bootstrap";
import { Navbar, Nav, NavItem } from "react-bootstrap";
import "./App.css";
import Routes from "./Routes";
// Is this really needed? relates to issue with navbar
import '../node_modules/bootstrap/dist/css/bootstrap.css';
import { AppContext } from "./libs/contextLib";
import { Auth } from "aws-amplify";


function App() {
  const [isAuthenticated, userHasAuthenticated] = useState(false);
  const [isAuthenticating, setIsAuthenticating] = useState(true);
  useEffect(() => {
    onLoad();
  }, []);
  const history = useHistory();

  async function onLoad() {
    try {
      await Auth.currentSession();
      userHasAuthenticated(true);
    }
    catch(e) {
      if (e !== 'No current user') {
        alert(e);
      }
    }
  
    setIsAuthenticating(false);
  }

  async function handleLogout() {
    await Auth.signOut();
    alert('You have been logged out')
    userHasAuthenticated(false);
    history.push("/login");
  }

  return (
    !isAuthenticating &&
    <div className="App container">
      <Navbar collapseOnSelect>
        <Navbar.Brand>
          <Link to="/">Grainstore UI</Link>
        </Navbar.Brand>
        <Navbar.Toggle />
        <Navbar.Collapse>
          <Nav>
            {isAuthenticated
              ? <NavItem onClick={handleLogout}>Logout</NavItem>
              : <>
                  <LinkContainer to="/login">
                    <NavItem>Login</NavItem>
                  </LinkContainer>
                </>
            }
          </Nav>
        </Navbar.Collapse>
      </Navbar>
      <AppContext.Provider
        value={{ isAuthenticated, userHasAuthenticated }}
      >
        <Routes />
      </AppContext.Provider>
    </div>
  );
}

export default App;