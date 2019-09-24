'use strict';

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('AllUserDetails', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.BIGINT
      },
      location: {
        type: Sequelize.GEOGRAPHY('POINTZM', 4326)
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        default: new Date()
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        default: new Date()
      }
    });
  },
  down: (queryInterface, Sequelize) => {
    return queryInterface.dropTable('AllUserDetails');
  }
};