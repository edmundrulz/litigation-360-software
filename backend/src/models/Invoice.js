const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Invoice', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    invoiceNumber: {
      type: DataTypes.STRING(50),
      unique: true,
      allowNull: false
    },
    invoiceDate: {
      type: DataTypes.DATE,
      allowNull: false
    },
    dueDate: {
      type: DataTypes.DATE,
      allowNull: false
    },
    subtotal: DataTypes.DECIMAL(12, 2),
    taxAmount: DataTypes.DECIMAL(12, 2),
    discountAmount: DataTypes.DECIMAL(12, 2),
    totalAmount: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false
    },
    paidAmount: {
      type: DataTypes.DECIMAL(12, 2),
      defaultValue: 0
    },
    status: {
      type: DataTypes.ENUM('draft', 'sent', 'paid', 'overdue', 'cancelled'),
      defaultValue: 'draft'
    },
    sentDate: DataTypes.DATE,
    paidDate: DataTypes.DATE,
    description: DataTypes.TEXT,
    notes: DataTypes.TEXT,
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