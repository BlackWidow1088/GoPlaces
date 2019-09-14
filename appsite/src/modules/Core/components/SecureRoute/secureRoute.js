import React from 'react'
import {Redirect, Route} from 'react-router-dom';

export const SecureRoute = ({ 
    component: Component, redirectToPathWhenFail: redirectPath, path: path, 
    routeGuard: guard 
}) => (
    <Route {...path} render={(props) => (
        guard() === true
        ? <Component {...props} />
        : <Redirect to={{
            pathname: redirectPath,
            state: { from: props.location }
          }} />
    )} />
  )

