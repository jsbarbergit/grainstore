import React from "react";
import { Route, Switch } from "react-router-dom";
import Home from "./containers/Home";
import NotFound from "./containers/NotFound";
import Login from "./containers/Login";

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
      {/* Finally, catch all unmatched routes */}
      <Route>
        <NotFound />
      </Route>
    </Switch>
  );
}