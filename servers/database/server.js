import _ from './app-config';
import models from './models';


async function addUser() {
    try {
        // TODO: provide inside the transaction for rollbacking entire case
        const user = await models.User.create({
            firstName: "Rushi", lastName: "Patil", email: "therushsinpatil9@gmail.com", password: '123', userName: 'rushsi9'
        });
        const query = `
        INSERT INTO "AllUserDetails" ("location", "UserId", "createdAt", "updatedAt")
        VALUES (ST_GeogFromText('SRID=4326;POINT ZM(-110 30 100 111)'), :userId, :created, :updated)
        `;
        models.sequelize.query(
            query,
            {
                type: models.sequelize.QueryTypes.INSERT,
                replacements: {
                    userId: user.id,
                    created: new Date(),
                    updated: new Date()
                },
            }).then(([results, metadata]) => {
                // Results will be an empty array and metadata will contain the number of affected rows.
            })
    } catch (err) {
        console.log(err);
    }
}

addUser().then(() => {
    console.log('added');
})

