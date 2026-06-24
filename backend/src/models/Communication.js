const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Communication', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    communicationType: {
      type: DataTypes.ENUM('email', 'sms', 'call', 'message', 'note'),
      allowNull: false
    },
    subject: DataTypes.STRING(255),
    body: DataTypes.TEXT,
    status: {
      type: DataTypes.ENUM('sent', 'received', 'draft', 'archived'),
      defaultValue: 'sent'
    },
    readAt: DataTypes.DATE,
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