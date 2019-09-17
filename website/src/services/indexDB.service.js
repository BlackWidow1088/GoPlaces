import storeOptions from '../env';
class IndexDBService {
    db;
    constructor() {
        var openRequest = indexedDB.open(storeOptions.storeName, storeOptions.version);
        openRequest.onupgradeneeded = (e) => {
            this.db = e.target.result;
            if (!this.db.objectStoreNames.contains('auth')) {
                this.db.createObjectStore('auth',
                    { keyPath: 'email' });
            }
        };
        openRequest.onsuccess = (e) => {
            this.db = e.target.result;

        };
        openRequest.onerror = (e) => {
            // TODO:   report to logger server

        };
    }

    add(data) {
        return new Promise((resolve, reject) => {
            var transaction = this.db.transaction('auth', 'readwrite');
            var auth = transaction.objectStore('auth');
            var item = {
                //   email: 'chavan.abhijeet1088@gmail.com',
                //   token: '123',
                ...data,
                created: new Date().getTime()
            };

            var request = auth.add(item);

            request.onerror = function (e) {
                //   console.log('Error', e.target.error.email);
                // TODO:   report to logger server
                reject(e);
            };
            request.onsuccess = function (e) {
                resolve(e);
            };
        });
    }

    update(data) {
        return new Promise((resolve, reject) => {
            var transaction = this.db.transaction('auth', 'readwrite');
            var auth = transaction.objectStore('auth');
            var item = {
                //   email: 'chavan.abhijeet1088@gmail.com',
                //   token: '123',
                ...data,
                created: new Date().getTime()
            };
            var deleteReq = auth.clear();
            deleteReq.onsuccess = function (e) {
                var request = auth.add(item)
                // var req = auth.openCursor(data.email);
                // var request;
                // req.onsuccess = function (e) {
                //     var cursor = e.target.result;
                //     if (cursor) { // key already exist
                //         request = auth.put(item);
                //     } else { // key not exist
                //         request = auth.add(item)
                //     }

                // };
                request.onerror = function (e) {
                    //   console.log('Error', e.target.error.email);
                    // TODO:   report to logger server
                    reject(e);
                };
                request.onsuccess = function (e) {
                    resolve(e)
                };
            }
        })
    }
    get() {
        return new Promise((resolve, reject) => {
            var tx = this.db.transaction('auth', 'readonly');
            var store = tx.objectStore('auth');
            var request = store.getAll();
            request.onerror = function (e) {
                // TODO:   report to logger server
                reject(e);
            };
            request.onsuccess = function () {
                resolve(request.result);
            }
        });
    }
}
export default new IndexDBService();