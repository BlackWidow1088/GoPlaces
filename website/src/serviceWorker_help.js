
 
//  self.addEventListener('fetch', function (event) {
//     if (event.request.url.includes('[yourservicecallName]')) {
//                event.respondWith(
//                    fetch(event.request).catch(function (result) {
//                       return readtheDatafromIndexedDb('firstDB', 'firstStore', event.request.url).then(function(response)
//                        {
//                            return response;
//                        });
//                    })
//                );
//            }
//  })
// function readtheDatafromIndexedDb(dbName, storeName, key) {
//     return new Promise((resolve, reject) => {
//      var openRequest = indexedDB.open(dbName, 2);
//      openRequest.onupgradeneeded = function (e) {
//          let db = request.result;
//          if (!db.objectStore.contains(storeName)) {
//              db.createObjectStore(storeName, { autoIncrement: true });
//          }
//      }
//      openRequest.onsuccess = function (e) {
//          console.log("Success!");
//          db = e.target.result;
//          var transaction = db.transaction([storeName], "readwrite");
//          var store = transaction.objectStore(storeName);
//          var request = store.get(key);
//          request.onerror = function () {
//              console.log("Error");
//              reject("unexpected error happened");
//          }
//          request.onsuccess = function (e) {
//              console.log("return the respose from db");
//              //JSON.parse(request.result)
//              resolve(new Response( request.result, { headers: { 'content-type':'text/plain' } } ));
//          }
//      }
//      openRequest.onerror = function (e) {
//          console.log("Error");
//          console.dir(e);
//      }
//     });
 
//  }

// intercepting fetch
// const fetch = window.fetch;
// window.fetch = (...args) => (async(args) => {
//     var result = await fetch(...args);
//     console.log('intercepting fetch');
//     console.log(result); // intercept response here
//     return result;
// })(args);