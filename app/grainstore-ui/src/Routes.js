import React from "react";
import { Route, Switch } from "react-router-dom";
import Home from "./containers/Home";
import NotFound from "./containers/NotFound";
import Login from "./containers/Login";
import Results from "./containers/Results";
import Data from "./containers/Data";

export default function Routes() {
  return (
    <Switch>
      {/* Home page */}
      <Route exact path="/">
        <Home />
      </Route>
      {/* Login Page */}
      <Route exact path="/login">
        <Login />
      </Route>
      {/* Search Results Page takes the customer id to search for*/}
      <Route exact path="/results/:customerId">
        <Results />
      </Route>
      <Route exact path="/results/:customerId/:record">
        <Data />
      </Route>
      {/* Finally, catch all unmatched routes */}
      <Route>
        <NotFound />
      </Route>
    </Switch>
  );
}