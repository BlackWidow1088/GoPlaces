"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _pg = require("pg");

const pool = new _pg.Pool({
  connectionString: process.env.DATABASE_URL
});
var _default = {
  /**
   * DB Query
   * @param {object} req
   * @param {object} res
   * @returns {object} object 
   */
  query(text, params) {
    return new Promise((resolve, reject) => {
      pool.query(text, params).then(res => {
        resolve(res);
      }).catch(err => {
        reject(err);
      });
    });
  }

};
exports.default = _default;