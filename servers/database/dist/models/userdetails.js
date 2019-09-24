'use strict';

module.exports = (sequelize, DataTypes) => {
  const UserDetails = sequelize.define('UserDetails', {
    location: DataTypes.GEOGRAPHY('POINTZM', 4326)
  }, {
    tableName: 'AllUserDetails',
    timestamps: true
  });

  UserDetails.associate = function (models) {
    // associations can be defined here
    models.UserDetails.User = models.UserDetails.belongsTo(models.User, {
      onDelete: "CASCADE",
      foreignKey: {
        allowNull: false
      }
    });
  };

  return UserDetails;
};