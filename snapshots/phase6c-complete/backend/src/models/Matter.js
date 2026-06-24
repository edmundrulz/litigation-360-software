const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Matter', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    matterNumber: {
      type: DataTypes.STRING(50),
      unique: true
    },
    title: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    description: DataTypes.TEXT,
    status: {
      type: DataTypes.ENUM('open', 'pending', 'closed', 'archived'),
      defaultValue: 'open'
    },
    practiceArea: DataTypes.STRING(100),
    subPracticeArea: DataTypes.STRING(100),
    caseType: DataTypes.STRING(100),
    filingDate: DataTypes.DATE,
    statuteOfLimitations: DataTypes.DATE,
    billingType: {
      type: DataTypes.ENUM('hourly', 'flatFee', 'contingency', 'hybrid'),
      defaultValue: 'hourly'
    },
    hourlyRate: DataTypes.DECIMAL(10, 2),
    flatFee: DataTypes.DECIMAL(12, 2),
    contingencyPercentage: DataTypes.DECIMAL(5, 2),
    retainerAmount: DataTypes.DECIMAL(12, 2),
    budget: DataTypes.DECIMAL(12, 2),
    opposingPartyName: DataTypes.STRING(255),
    opposingCounselName: DataTypes.STRING(255),
    judgeName: DataTypes.STRING(255),
    courtName: DataTypes.STRING(255),
    caseNumber: DataTypes.STRING(50),
    jurisdiction: DataTypes.STRING(100),
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