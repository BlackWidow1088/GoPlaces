/*
Copyright 2018 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
const env = require('../env');
const path = require('path');

const expressApp = require('express');
const app = expressApp();
app.use('/', expressApp.static('./appsite'));
app.use('/static', expressApp.static('./appsite/static'));
const serverApp = app.listen(env.appsite, () => {

    const host = serverApp.address().address;
    const port = serverApp.address().port;

    console.log('App listening at http://%s:%s', host, port);
});

const expressWeb = require('express');
const web = expressWeb();
web.use('/', expressWeb.static('./website'));
web.use('/static', expressWeb.static('./website/static'));
const serverWeb = web.listen(env.website, () => {

    const host = serverWeb.address().address;
    const port = serverWeb.address().port;

    console.log('App listening at http://%s:%s', host, port);
});

var http = require('http');
var httpProxy = require('http-proxy');

// const type = process.argv[2];

// var GUI_URL = 'http://localhost:5050';
// if(type === 'dev') {
//   GUI_URL = 'http://localhost:4200';
// }

// NOTE: will be replaced by nginx configs
// NOTE: these web urls for app, auth and website cannot be accessed from any client side
var APP_PATHS = ['/app'];
var APP_URL = `${env.domain}:${env.app}`;

var AUTH_PATHS = ['/auth'];
var AUTH_URL =  `${env.domain}:${env.auth}`;

var SITE_PATHS = ['/'];
var WEBSITE_URL =  `${env.domain}:${env.website}`;
var APPSITE_URL =  `${env.domain}:${env.appsite}`;

var proxy = httpProxy.createProxyServer({ changeOrigin: true });
var server = http.createServer(function (req, res) {
  for (var i = 0; i < SITE_PATHS.length; i++) {
    if (req.url.startsWith(SITE_PATHS[i])) {
    if(req.headers.cookie) {
      target = APPSITE_URL;
    } else {
      target = WEBSITE_URL;
    }
    break;
    }
  }
  for (var i = 0; i < APP_PATHS.length; i++) {
    if (req.url.startsWith(APP_PATHS[i])) {
    target = APP_URL;
    break;
    }
  }
  for (var i = 0; i < AUTH_PATHS.length; i++) {
    if (req.url.startsWith(AUTH_PATHS[i])) {
      target = AUTH_URL;
      break;
    }
}

  proxy.web(req, res, { target: target });

  proxy.on('error', function (e) {
    console.log(`${'Proxy Error:'}${e}`);
  });

});

console.log('Proxy Server listening on port');
server.listen(env.reverse_proxy);

