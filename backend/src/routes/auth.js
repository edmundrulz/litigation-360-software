const express = require('express');
const { User } = require('../models');
const authMiddleware = require('../middleware/auth');
const logger = require('../utils/logger');
const { issueToken } = require('../security/tokenService');
const { sessionRegistry } = require('../security/sessionRegistry');
const { loginThrottle } = require('../security/loginThrottle');

const router = express.Router();

// POST /api/auth/register
router.post('/register', async (req, res) => {
  try {
    const { email, password, firstName, lastName, firmId } = req.body;

    // Validate input
    if (!email || !password || !firstName || !lastName) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Check if user exists
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(409).json({ error: 'User already exists' });
    }

    // Create user
    const user = await User.create({
      email,
      passwordHash: password,
      firstName,
      lastName,
      firmId: firmId || null
    });

    // Generate token
    const { token, sessionId } = issueToken(user, { ipAddress: req.ip, event: 'register' });

    logger.info(`User registered: ${email}`);

    res.status(201).json({
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      token,
      sessionId
    });
  } catch (error) {
    logger.error(`Register error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

// POST /api/auth/login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    const throttleState = loginThrottle.status(email, req.ip);
    if (throttleState.blocked) {
      res.set('Retry-After', String(Math.ceil(throttleState.retryAfterMs / 1000)));
      return res.status(429).json({ error: 'Too many failed login attempts' });
    }

    const user = await User.findOne({ where: { email } });
    if (!user) {
      loginThrottle.failure(email, req.ip);
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const isValidPassword = await user.validatePassword(password);
    if (!isValidPassword) {
      loginThrottle.failure(email, req.ip);
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    if (!user.isActive) {
      return res.status(401).json({ error: 'Account is inactive' });
    }

    loginThrottle.success(email, req.ip);
    const { token, sessionId } = issueToken(user, { ipAddress: req.ip, event: 'login' });

    user.lastLogin = new Date();
    await user.save();

    logger.info(`User logged in: ${email}`);

    res.json({
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      role: user.role,
      token,
      sessionId
    });
  } catch (error) {
    logger.error(`Login error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

router.post('/logout', authMiddleware, (req, res) => {
  sessionRegistry.revoke(req.user.sessionId);
  res.json({ success: true });
});

// GET /api/auth/me
router.get('/me', authMiddleware, async (req, res) => {
  try {
    const user = await User.findByPk(req.user.userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user.toSafeJSON());
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
