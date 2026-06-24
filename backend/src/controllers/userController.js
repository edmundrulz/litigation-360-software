const { User } = require("../models");

function sanitizeUser(user) {
  if (!user) return null;

  const plain = typeof user.toJSON === "function" ? user.toJSON() : user;

  delete plain.passwordHash;
  delete plain.mfaSecret;

  return plain;
}

function getAllowedRoles() {
  return User.rawAttributes.role.values;
}

async function getUsers(req, res) {
  try {
    const users = await User.findAll({
      order: [["createdAt", "DESC"]],
    });

    res.json({
      success: true,
      count: users.length,
      users: users.map(sanitizeUser),
    });
  } catch (error) {
    console.error("getUsers error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to load users",
    });
  }
}

async function createUser(req, res) {
  try {
    const {
      email,
      password,
      firstName,
      lastName,
      role,
    } = req.body;

    if (!email || !password || !firstName || !lastName) {
      return res.status(400).json({
        success: false,
        message: "email, password, firstName, and lastName are required",
      });
    }

    const allowedRoles = getAllowedRoles();
    const finalRole = role || "legal_assistant_clerk";

    if (!allowedRoles.includes(finalRole)) {
      return res.status(400).json({
        success: false,
        message: "Invalid role",
        allowedRoles,
      });
    }

    const user = await User.create({
      email,
      passwordHash: password,
      firstName,
      lastName,
      role: finalRole,
      isActive: true,
    });

    res.status(201).json({
      success: true,
      message: "User created",
      user: sanitizeUser(user),
    });
  } catch (error) {
    console.error("createUser error:", error);

    if (error.name === "SequelizeUniqueConstraintError") {
      return res.status(409).json({
        success: false,
        message: "User email already exists",
      });
    }

    res.status(500).json({
      success: false,
      message: "Failed to create user",
    });
  }
}

async function deleteUser(req, res) {
  try {
    const { id } = req.params;

    const deleted = await User.destroy({
      where: { id },
    });

    if (!deleted) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    res.json({
      success: true,
      message: "User deleted",
    });
  } catch (error) {
    console.error("deleteUser error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to delete user",
    });
  }
}

module.exports = {
  getUsers,
  createUser,
  deleteUser,
};
