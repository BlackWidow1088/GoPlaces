import React from 'react';
import Login from './components/Login/login';
import ThirdPartyLogin from './components/ThirdPartyLogin/thirdPartyLogin';
import validation from './utilities/validation';
import './App.css';

class App extends React.Component {
  constructor() {
    super();
    this.state = {
      isLogin: true
    }
  }
  createAccount() {
    console.log('called account');
  }
  forgotPassword() {
    console.log('called password');
  }
  fields = [
    { placeholder: 'Email', type: 'text', name: 'email', value: '' },
    { placeholder: 'Password', type: 'password', name: 'password', value: '' }
  ];
  signInFields = [
    { placeholder: 'User Name', type: 'text', name: 'username', value: '' },
    { placeholder: 'Email', type: 'text', name: 'email', value: '' },
    { placeholder: 'Password', type: 'password', name: 'password', value: '' },
  ]
  render() {
    return (
      <div className="gp-app">
        {
          this.state.isLogin &&
          <div>
            <div className='gp-signin-label'>
              Sign In With
            </div>
            <ThirdPartyLogin />
            <div className='gp-or-label'>
              or
            </div>
            <Login fields={this.fields} validation={validation} />
            <div>
              <span className='gp-create-link' onClick={() => this.createAccount()}>Create</span>
              <span className='gp-forgot-link' onClick={() => this.forgotPassword()}>Forgot</span>
            </div>
          </div>
        }
        {
          !this.state.isLogin && 
          <Signin fields={this.signInFields} validation={validation}></Signin>
        }
      </div>
    );
  }

}

export default App;
