const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Firm', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false
    },
    address: DataTypes.STRING,
    city: DataTypes.STRING,
    state: DataTypes.STRING(2),
    zipCode: DataTypes.STRING(10),
    phone: DataTypes.STRING(20),
    website: DataTypes.STRING,
    billingEmail: DataTypes.STRING,
    trustAccountName: DataTypes.STRING,
    trustAccountNumber: DataTypes.STRING(50),
    bankRoutingNumber: DataTypes.STRING(9),
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