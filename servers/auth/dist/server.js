"use strict";

var _config = _interopRequireDefault(require("./config.js"));

var _reflection = _interopRequireDefault(require("./src/controllers/reflection.controller"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

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

const path = require('path');

const cookieParser = require('cookie-parser');

const jwt = require('jsonwebtoken');

const fs = require('fs');

const TIMEOUT = '604800000';
const RSA_PRIVATE_KEY = fs.readFileSync(path.join(__dirname, './keys/private.key'));

const def = async function () {
  console.log('do it');
};

const def2 = async function () {
  await def();
};

def2();
const app = express();
app.use(express.static(path.join(__dirname, './public')));
app.use(cookieParser()); // Parse URL-encoded bodies (as sent by HTML forms)

app.use(express.urlencoded()); // Parse JSON bodies (as sent by API clients)

app.use(express.json());
app.route('/auth').post(loginRoute);
app.post('/auth/v1/reflections', _reflection.default.create);
app.get('/auth/v1/reflections', _reflection.default.getAll);
app.get('/auth/v1/reflections/:id', _reflection.default.getOne);
app.put('/auth/v1/reflections/:id', _reflection.default.update);
app.delete('/auth/v1/reflections/:id', _reflection.default.delete);

function loginRoute(req, res) {
  const email = req.body.email,
        password = req.body.password;

  if (validateEmailAndPassword({
    email,
    password
  })) {
    const userId = findUserIdForEmail(email);
    const jwtBearerToken = jwt.sign({}, RSA_PRIVATE_KEY, {
      algorithm: 'RS256',
      expiresIn: TIMEOUT,
      subject: userId
    });
    const token = {
      idToken: jwtBearerToken,
      expiresIn: TIMEOUT
    };
    res.cookie('goplaces', JSON.stringify(token), {
      maxAge: TIMEOUT,
      httpOnly: true
    });
    res.status(200).json(token);
  } else {
    // send status 401 Unauthorized
    res.sendStatus(401);
  }
}

function findUserIdForEmail(email) {
  return 'abhijeet';
}

function validateEmailAndPassword(details) {
  if (details.email === 'a' && details.password === 'a') {
    return true;
  }

  return false;
}

const server = app.listen(process.env.auth, () => {
  const host = server.address().address;
  const port = server.address().port;
  console.log('App listening at http://%s:%s', host, port);
});