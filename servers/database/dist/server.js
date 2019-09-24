"use strict";

var _appConfig = _interopRequireDefault(require("./app-config"));

var _models = _interopRequireDefault(require("./models"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

async function addUser() {
  try {
    const user = await _models.default.User.create({
      firstName: "Rushi",
      lastName: "Patil",
      email: "therushsinpatil9@gmail.com",
      password: '123',
      userName: 'rushsi9'
    });
    const query = `
        INSERT INTO "AllUserDetails" ("location", "UserId", "createdAt", "updatedAt")
        VALUES (ST_GeogFromText('SRID=4326;POINT ZM(-110 30 100 111)'), :userId, :created, :updated)
        `;

    _models.default.sequelize.query(query, {
      type: _models.default.sequelize.QueryTypes.INSERT,
      replacements: {
        userId: user.id,
        created: new Date(),
        updated: new Date()
      }
    }).then(([results, metadata]) => {// Results will be an empty array and metadata will contain the number of affected rows.
    });
  } catch (err) {
    console.log(err);
  }
}

addUser().then(() => {
  console.log('added');
});