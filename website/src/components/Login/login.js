
import React, { Component } from 'react';
import authService from '../../services/auth.service';

class Login extends Component {
    authUrl='http://localhost:8081/auth';
    constructor(props) {
        super(props);
        this.state={
            email: '',
            password: ''
        }
    }
    handleEmailChange(event) {
        this.setState({
            email: event.target.value
        })
        event.preventDefault();
    }
    handlePasswordChange(event) {
        this.setState({
            password: event.target.value
        })
        event.preventDefault();
    }
    handleSubmit(event) {
        console.log('state ', this.state);
        authService.login({email: this.state.email, password: this.state.password});
        event.preventDefault();
    }

    render() {
        return (<div className='gp-card'>
        <form onSubmit={(event) => this.handleSubmit(event)}>
            <div className='gp-login'>
                <input placeholder='Email' value={this.state.email} onChange={(event) => this.handleEmailChange(event)}/>
            </div>
            <div className='gp-password'>
                <input placeholder='Password' type='password' value={this.state.password} onChange={(event) => this.handlePasswordChange(event) }/>
            </div>
            <div className='gp-login-btn'>
                <button type='submit'>Login</button>
            </div>
            </form>
        </div>);
    }
}

export default Login;