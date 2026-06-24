const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/authenticateToken');
const authorize = require('../middleware/authorize');
const { getUsers, createUser, deleteUser } = require('../controllers/userController');

// Protect all routes with auth middleware first
router.use(authenticateToken);

// Only Admin and Managing Partner can view users
router.get('/', authorize(['Administrator', 'Managing Partner']), getUsers);

// Only Administrator can create new users
router.post('/', authorize(['Administrator']), createUser);

// Only Administrator can delete users
router.delete('/:id', authorize(['Administrator']), deleteUser);

module.exports = router;
