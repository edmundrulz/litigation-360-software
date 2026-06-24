const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/authenticateToken');
const authorize = require('../middleware/authorize');
const { getUsers, createUser, deleteUser } = require('../controllers/userController');

// Protect all routes with auth middleware first
router.use(authenticateToken);

// Only Admin and Managing Partner can view users
router.get('/', authorize(['administrator', 'managing_partner/senior_lawyer']), getUsers);

// Only Administrator can create new users
router.post('/', authorize(['administrator']), createUser);

// Only Administrator can delete users
router.delete('/:id', authorize(['administrator']), deleteUser);

module.exports = router;


