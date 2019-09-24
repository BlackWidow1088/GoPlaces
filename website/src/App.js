import React from 'react';
import Login from './components/Login/login';
import ThirdPartyLogin from './components/ThirdPartyLogin/thirdPartyLogin';
import './App.css';

function App() {
  return (
    <div className="gp-app">
      <Login></Login>
      <ThirdPartyLogin />
    </div>
  );
}

export default App;
