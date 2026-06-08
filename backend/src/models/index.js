const { Sequelize } = require('sequelize');
const logger = require('../utils/logger');

const sequelize = new Sequelize(
  process.env.DB_NAME || 'litigation_360',
  process.env.DB_USER || 'postgres',
  process.env.DB_PASSWORD || 'postgres',
  {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    dialect: 'postgres',
    logging: (msg) => logger.debug(msg),
    pool: {
      max: 10,
      min: 2,
      acquire: 30000,
      idle: 10000
    }
  }
);

// Import models
const User = require('./User')(sequelize);
const Firm = require('./Firm')(sequelize);
const Client = require('./Client')(sequelize);
const Matter = require('./Matter')(sequelize);
const Document = require('./Document')(sequelize);
const TimeEntry = require('./TimeEntry')(sequelize);
const Invoice = require('./Invoice')(sequelize);
const Communication = require('./Communication')(sequelize);
const Task = require('./Task')(sequelize);

// Define associations
Firm.hasMany(User, { foreignKey: 'firmId' });
User.belongsTo(Firm, { foreignKey: 'firmId' });

Firm.hasMany(Client, { foreignKey: 'firmId' });
Client.belongsTo(Firm, { foreignKey: 'firmId' });

Client.hasMany(Matter, { foreignKey: 'clientId' });
Matter.belongsTo(Client, { foreignKey: 'clientId' });

Firm.hasMany(Matter, { foreignKey: 'firmId' });
Matter.belongsTo(Firm, { foreignKey: 'firmId' });

Matter.hasMany(Document, { foreignKey: 'matterId' });
Document.belongsTo(Matter, { foreignKey: 'matterId' });

Matter.hasMany(TimeEntry, { foreignKey: 'matterId' });
TimeEntry.belongsTo(Matter, { foreignKey: 'matterId' });

User.hasMany(TimeEntry, { foreignKey: 'userId' });
TimeEntry.belongsTo(User, { foreignKey: 'userId' });

Matter.hasMany(Invoice, { foreignKey: 'matterId' });
Invoice.belongsTo(Matter, { foreignKey: 'matterId' });

Matter.hasMany(Communication, { foreignKey: 'matterId' });
Communication.belongsTo(Matter, { foreignKey: 'matterId' });

Matter.hasMany(Task, { foreignKey: 'matterId' });
Task.belongsTo(Matter, { foreignKey: 'matterId' });

module.exports = {
  sequelize,
  User,
  Firm,
  Client,
  Matter,
  Document,
  TimeEntry,
  Invoice,
  Communication,
  Task
};