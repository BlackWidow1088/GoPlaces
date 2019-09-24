'use strict';

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.bulkInsert('Users', [{
      firstName: 'Abhijeet',
      lastName: 'Chavan',
      email: 'chavan.abhijeet1088@gmail.com',
      password: '0909',
      userName: 'BlackWidow',
      createdAt: new Date(),
      updatedAt: new Date()
    }], {});
  },
  down: (queryInterface, Sequelize) => {
    return queryInterface.bulkDelete('Users', null, {});
  }
};