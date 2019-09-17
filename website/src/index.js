import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';

import authService from './services/auth.service';

ReactDOM.render(<App />, document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister({
    onUpdate: function() {
        authService.redirect();
    },
    onSuccess: function() {
        authService.redirect();
    },
    onWebsiteLoad: function() {
        authService.redirect();
    }
});

// if (!('indexedDB' in window)) {
//   console.log('This browser doesn\'t support IndexedDB');
//   // using localStorage to save token
// }

