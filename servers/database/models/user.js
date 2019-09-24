'use strict';
module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {
    firstName: DataTypes.STRING,
    lastName: DataTypes.STRING,
    userName: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false
    },
    email: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false
    },
    location: {
      type: DataTypes.GEOGRAPHY('POINT')
    },
    phone: {
      type: DataTypes.STRING
    }
    //   TODO: add location having POSTGIS GEOGRAPHY type.
  }, {tableName: 'Users', timestamps: true});
  User.associate = function (models) {
    // associations can be defined here
    models.User.UserDetails = models.User.hasOne(models.UserDetails);
  };
  return User;
};