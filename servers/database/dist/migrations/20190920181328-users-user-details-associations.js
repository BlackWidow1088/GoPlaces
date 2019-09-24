'use strict';

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.addColumn('AllUserDetails', // name of Source model
    'UserId', // name of the key we're adding 
    {
      type: Sequelize.BIGINT,
      allowNull: false,
      references: {
        model: 'Users',
        // name of Target model
        key: 'id' // key in Target model that we're referencing

      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE'
    });
  },
  down: (queryInterface, Sequelize) => {
    return queryInterface.removeColumn('AllUserDetails', // name of Source model
    'UserId');
  }
};