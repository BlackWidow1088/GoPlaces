
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import React, { Suspense, lazy } from 'react';
import { Provider } from 'react-redux';

import configureStore from './store';
import { AuthGuard } from './modules/Authentication/guards';
import {SecureRoute} from './modules/Core/components/SecureRoute/secureRoute';

import './App.scss';

const Main = lazy(() => import('./modules/Main/main'));
const Login = lazy(() => import('./modules/Authentication/components/Login/login'));
const store = configureStore();

function App() {
  return (
    <Provider store={store}>
      <div className="gp-app">
        <Router>
          <Suspense fallback={<div>Loading...</div>}>
            <Switch>
              <SecureRoute path='/' component={Main} routeGuard={AuthGuard.authenticate} redirectToPathWhenFail='/login' />
              {/* <Route exact path='/login' component={Login} /> */}
            </Switch>
          </Suspense>
        </Router>
      </div>
    </Provider>
  );
}

export default App;
