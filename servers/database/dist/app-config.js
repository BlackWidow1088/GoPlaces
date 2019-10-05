"use strict";

var _dotenv = _interopRequireDefault(require("dotenv"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var path = require('path');

var parent = path.resolve(__dirname, '../../');

_dotenv.default.config({
  path: path.join(parent, '.env')
});