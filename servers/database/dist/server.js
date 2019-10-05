"use strict";

var _appConfig = _interopRequireDefault(require("./app-config"));

var _models = _interopRequireDefault(require("./models"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function addUser() {
  return _addUser.apply(this, arguments);
}

function _addUser() {
  _addUser = _asyncToGenerator(function* () {
    try {
      // TODO: provide inside the transaction for rollbacking entire case
      var user = yield _models.default.User.create({
        firstName: "Rushi",
        lastName: "Patil",
        email: "therushsinpatil9@gmail.com",
        password: '123',
        userName: 'rushsi9'
      });
      var query = "\n        INSERT INTO \"AllUserDetails\" (\"location\", \"UserId\", \"createdAt\", \"updatedAt\")\n        VALUES (ST_GeogFromText('SRID=4326;POINT ZM(-110 30 100 111)'), :userId, :created, :updated)\n        ";

      _models.default.sequelize.query(query, {
        type: _models.default.sequelize.QueryTypes.INSERT,
        replacements: {
          userId: user.id,
          created: new Date(),
          updated: new Date()
        }
      }).then((_ref) => {// Results will be an empty array and metadata will contain the number of affected rows.

        var [results, metadata] = _ref;
      });
    } catch (err) {
      console.log(err);
    }
  });
  return _addUser.apply(this, arguments);
}

addUser().then(() => {
  console.log('added');
});