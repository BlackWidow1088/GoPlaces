'use strict';

const fs = require('fs');
const path = require('path');
const Sequelize = require('sequelize');

// const env = process.env.NODE_ENV || 'development';
// const config = require(__dirname + '/../config/config.json')[env];
export default (): any => {
  const db = {sequelize: null, Sequelize: null};
  const basename = path.basename(__filename);
  const {
    username,
    password,
    database,
    host,
    dialect,
    operatorsAliases,
  } = process.env;
  let sequelize = new Sequelize(process.env.database, process.env.username, process.env.password, {
    username,
    password,
    database,
    host,
    dialect,
    operatorsAliases,
  });
  // let sequelize;
  // if (config.use_env_variable) {
  //   sequelize = new Sequelize(process.env[config.use_env_variable], config);
  // } else {
  //   sequelize = new Sequelize(config.database, config.username, config.password, config);
  // }

  fs
    .readdirSync(__dirname)
    .filter(file => {
      return (file.indexOf('.') !== 0) && (file !== basename) && (file.slice(-3) === '.js');
    })
    .forEach(file => {
      const model = sequelize['import'](path.join(__dirname, file));
      db[model.name] = model;
    });

  Object.keys(db).forEach(modelName => {
    if (db[modelName].associate) {
      db[modelName].associate(db);
    }
  });
  Object.keys(db).forEach(modelName => {
    if (db[modelName].associate) {
      console.log(db[modelName])
    }
  })

  db.sequelize = sequelize;
  db.Sequelize = Sequelize;
  return db;
}

