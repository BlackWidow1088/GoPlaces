"use strict";

var _dotenv = _interopRequireDefault(require("dotenv"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const path = require('path');

const parent = path.resolve(__dirname, '../../');

_dotenv.default.config({
  path: path.join(parent, '.env')
});