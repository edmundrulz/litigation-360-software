const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Client', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    firstName: DataTypes.STRING,
    lastName: DataTypes.STRING,
    companyName: DataTypes.STRING,
    email: {
      type: DataTypes.STRING,
      validate: { isEmail: true }
    },
    phone: DataTypes.STRING(20),
    alternatePhone: DataTypes.STRING(20),
    address: DataTypes.STRING,
    city: DataTypes.STRING,
    state: DataTypes.STRING(2),
    zipCode: DataTypes.STRING(10),
    billingAddress: DataTypes.STRING,
    billingCity: DataTypes.STRING,
    billingState: DataTypes.STRING(2),
    billingZip: DataTypes.STRING(10),
    clientType: {
      type: DataTypes.ENUM('individual', 'corporate'),
      defaultValue: 'individual'
    },
    communicationPreference: {
      type: DataTypes.ENUM('email', 'phone', 'sms', 'portal'),
      defaultValue: 'email'
    },
    createdAt: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    },
    updatedAt: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    }
  }, {
    timestamps: true
  });
};