const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Document', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    filename: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    filePath: DataTypes.STRING(500),
    fileSize: DataTypes.BIGINT,
    mimeType: DataTypes.STRING(50),
    documentType: DataTypes.STRING(100),
    category: DataTypes.STRING(100),
    confidentialityLevel: {
      type: DataTypes.ENUM('public', 'internal', 'confidential', 'privileged'),
      defaultValue: 'confidential'
    },
    s3Key: DataTypes.STRING(500),
    s3Bucket: DataTypes.STRING(255),
    contentHash: DataTypes.STRING(64),
    versionNumber: {
      type: DataTypes.INTEGER,
      defaultValue: 1
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