const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');

module.exports = (sequelize) => {
  const User = sequelize.define('User', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    email: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false,
      lowercase: true,
      validate: { isEmail: true }
    },
    passwordHash: {
      type: DataTypes.STRING,
      allowNull: false
    },
    firstName: {
      type: DataTypes.STRING,
      allowNull: false
    },
    lastName: {
      type: DataTypes.STRING,
      allowNull: false
    },
    role: {
  type: DataTypes.ENUM(
    'administrator',
    'managing_partner/senior_lawyer',
    'junior_lawyer',
    'consultant_lawyer',
    'legal_assistant_clerk',
    'chambering_student',
    'accountant_auditor',
    'client',
    'guest'
  ),
  allowNull: false,
  defaultValue: 'legal_assistant_clerk'
},
  
    isActive: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    },
    mfaEnabled: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    },
    mfaSecret: {
      type: DataTypes.STRING,
      allowNull: true
    },
    lastLogin: {
      type: DataTypes.DATE,
      allowNull: true
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
    timestamps: true,
    hooks: {
      beforeCreate: async (user) => {
        user.passwordHash = await bcrypt.hash(user.passwordHash, 10);
      }
    }
  });

  User.prototype.validatePassword = async function(password) {
    return bcrypt.compare(password, this.passwordHash);
  };

  User.prototype.toSafeJSON = function() {
  const values = { ...this.get() };
  delete values.passwordHash;
  delete values.mfaSecret;
  return values;
};

  return User;
};