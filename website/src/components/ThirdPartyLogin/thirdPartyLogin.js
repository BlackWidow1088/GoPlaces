
import React, { Component } from 'react';
import authService from '../../services/auth.service';
import storeOptions from '../env';

class ThirdPartyLogin extends Component {
    render() {
        return <div>
            <FacebookLogin
                appId={storeOptions.FACEBOOK_APP_ID}
                autoLoad={false}
                fields="name,email,picture"
                callback={this.facebookResponse} />
            <GoogleLogin
                clientId={storeOptions.GOOGLE_CLIENT_ID}
                buttonText="Login"
                onSuccess={this.googleResponse} />
        </div>
    }

    facebookResponse = (response) => {
        const tokenBlob = new Blob([JSON.stringify({access_token: response.accessToken}, null, 2)], {type : 'application/json'});
        const options = {
            method: 'POST',
            body: tokenBlob,
            mode: 'cors',
            cache: 'default'
        };
        authService.login({body: tokenBlob});
        fetch('http://localhost:4000/api/v1/auth/facebook', options).then(r => {
            const token = r.headers.get('x-auth-token');
            r.json().then(user => {
                if (token) { 
                    this.setState({isAuthenticated: true, user, token})
                }
            });
        });
    };

    googleResponse = (response) => {
        const tokenBlob = new Blob([JSON.stringify({access_token: response.accessToken}, null, 2)], {type : 'application/json'});
        const options = {
            method: 'POST',
            body: tokenBlob,
            mode: 'cors',
            cache: 'default'
        };
        fetch('http://localhost:4000/api/v1/auth/google', options).then(r => {
            const token = r.headers.get('x-auth-token');
            r.json().then(user => {
                if (token) {
                    this.setState({isAuthenticated: true, user, token})
                }
            });
        })
    };

}

export default ThirdPartyLogin;
