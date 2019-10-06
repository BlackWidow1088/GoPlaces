import indexDBService from './indexDB.service';
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
        try {
            const response = await axios.post(process.env.REACT_APP_authLoginUrl, { email: email, password: password });
            const data = await response.data;
            indexDBService.update({ email: email, ...data }).then(e => {
                this.redirect();
            }, error => {
                console.log('problem updating indexDB');
            });
        } catch (ex) {
            console.log(ex);
        }

    }

    async create({email, password, username}) {
        try {
            const response = await axios.post(process.env.REACT_APP_authSignupUrl, {email, password, username});
            const data = await response.data;
            indexDBService.update({ email: email, ...data }).then(e => {
                this.redirect();
            }, error => {
                console.log('problem updating indexDB');
            });
        } catch (ex) {
            console.log(ex);
        }
    }

    async thirdPartyLogin() {
        const response = await axios.post()
    }
}

export default new AuthService();