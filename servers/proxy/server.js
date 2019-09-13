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

const express = require('express');
const app = express();
const bodyParser = require('body-parser');//Parse JSON requests
const path = require('path');
app.use(express.static(path.join(__dirname, 'build_website')));
app.use(express.static(path.join(__dirname, 'build_app')));
// app.use(express.static(path.join(__dirname, 'website')));
// This serves static files from the specified directory
// app.use(express.static('../app'));
// Parse URL-encoded bodies (as sent by HTML forms)
app.use(express.urlencoded());

// Parse JSON bodies (as sent by API clients)
app.use(express.json());

app.get('/', (req,res) => res.sendFile(path.join(__dirname, 'build_app/index.html')));
// app.get('*', (req, res) => {
//     res.sendFile(path.join(__dirname, 'website/index.html'));
// });
// app.use('/', (req, res) => {
//   return res.redirect('https://www.google.com');
// })

const server = app.listen(8080, () => {

    const host = server.address().address;
    const port = server.address().port;

    console.log('App listening at http://%s:%s', host, port);
});
