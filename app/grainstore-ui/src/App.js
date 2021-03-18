import React, { useState, useEffect } from "react";
import { Link, useHistory } from "react-router-dom";
import { LinkContainer } from "react-router-bootstrap";
import { Navbar, Nav, NavItem } from "react-bootstrap";
import "./App.css";
import "./footer.css";
import config from './config';
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
  const [customerId, setCustomerId ] = useState("");

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
    userHasAuthenticated(false);
    history.push("/login");
  }

  const searchChange = ({target}) => {
    setCustomerId(target.value);
  }

  const doSearch = () => {
    history.push('/results/' + customerId)
  }

  return (
    !isAuthenticating &&
    <div className="App container">
      <Navbar collapseOnSelect>
        <Navbar.Brand>
          <h1><Link to="/">Grainstore UI</Link></h1>
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
        <Nav>
          {isAuthenticated
            ? <NavItem>
              <form className="form-inline" onSubmit={doSearch}>
                <input  className="form-control mr-sm-2" 
                        type="search" 
                        placeholder="Enter CustomerId" 
                        aria-label="Enter CustomerId"
                        value={customerId}
                        onChange={searchChange}
                        >
                </input>
                <button className="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
              </form>
            </NavItem>
            : <>
              </>
          }
        </Nav>
      </Navbar>
      <AppContext.Provider
        value={{ isAuthenticated, userHasAuthenticated }}
      >
        <Routes />
      </AppContext.Provider>
      <footer id="sticky-footer">
        <div class="container text-center">
          <small>Grainstore UI Version: {config.app.VERSION}</small>
        </div>
      </footer>
    </div>

  );
}

export default App;