import indexDBService from './indexDB.service';
import storeOptions from '../env';
import axios from 'axios';
class AuthService {
    async redirect() {
        indexDBService.get().then(async data => {
            if (data.length) {
                // await axios.get(storeOptions.appUrl, { headers: { Authorization: 'Bearer '+data.token }});
                window.location.reload();

                // await axios.get(storeOptions.appUrl);
                // window.location.replace(storeOptions.appUrl);
            }
        })
    }

    async login({ email, password }) {
        const response = await axios.post(storeOptions.authUrl, { email: email, password: password });
        const data = await response.data;
        indexDBService.update({email: email, ...data}).then(e => {
            this.redirect();
        })
        //   console.log(await response.json());
        // fetch(storeOptions.authUrl, {
        //     method: 'POST', // *GET, POST, PUT, DELETE, etc.
        //     mode: 'no-cors', // no-cors, cors, *same-origin
        //     // cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        //     // credentials: 'same-origin', // include, *same-origin, omit
        //     headers: {
        //         'Content-Type': 'application/json',
        //         // 'Content-Type': 'application/x-www-form-urlencoded',
        //     },
        //     // redirect: 'follow', // manual, *follow, error
        //     // referrer: 'no-referrer', // no-referrer, *client,
        //     body: JSON.stringify({ email, password })
        // })
        //     .then(response => {
        //         return response.json();
        //         // window.location.replace(storeOptions.authUrl);
        //     }).then(data => {
        //         console.log('response from auth server')
        //         console.log(data);
        //     });
    }

    async thirdPartyLogin() {
        const response = await axios.post()
    }
}

export default new AuthService();