const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('TimeEntry', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    dateWorked: {
      type: DataTypes.DATE,
      allowNull: false
    },
    hoursWorked: {
      type: DataTypes.DECIMAL(6, 2),
      allowNull: false
    },
    minutesWorked: DataTypes.INTEGER,
    billable: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    },
    billingRate: DataTypes.DECIMAL(10, 2),
    totalBillingAmount: DataTypes.DECIMAL(12, 2),
    utbmsCode: DataTypes.STRING(10),
    taskCategory: DataTypes.STRING(100),
    description: DataTypes.TEXT,
    status: {
      type: DataTypes.ENUM('draft', 'submitted', 'approved', 'billed'),
      defaultValue: 'draft'
    },
    approvedAt: DataTypes.DATE,
    invoiceId: DataTypes.UUID,
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