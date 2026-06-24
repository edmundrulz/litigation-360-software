const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const db = require('../database');

const router = express.Router();

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';
const JWT_EXPIRY = '24h';

db.exec(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    role_id INTEGER,
    role TEXT NOT NULL DEFAULT 'legal_assistant_clerk',
    staff_id INTEGER,
    is_active INTEGER DEFAULT 1,
    last_login DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES staff(id)
  );
`);

function writeAudit(userEmail, action, entityType, entityId, oldValue, newValue, ipAddress) {
  try {
    db.prepare(`
      INSERT INTO audit_logs 
      (user_email, action, entity_type, entity_id, old_value, new_value, ip_address)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `).run(
      userEmail || 'system',
      action,
      entityType || 'AUTH',
      entityId || null,
      oldValue ? JSON.stringify(oldValue) : null,
      newValue ? JSON.stringify(newValue) : null,
      ipAddress || null
    );
  } catch (error) {
    console.error('Audit log write failed:', error.message);
  }
}

function writeSecurityEvent(email, eventType, ipAddress, details) {
  try {
    db.prepare(`
      INSERT INTO security_events
      (email, event_type, ip_address, details)
      VALUES (?, ?, ?, ?)
    `).run(
      email || null,
      eventType,
      ipAddress || null,
      details || null
    );
  } catch (error) {
    console.error('Security event write failed:', error.message);
  }
}

function authenticateSqliteToken(req, res, next) {
  try {
    const authHeader = req.headers.authorization || '';
    const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;

    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const decoded = jwt.verify(token, JWT_SECRET);
    const user = db.prepare(`
      SELECT id, email, full_name, role, role_id, staff_id, is_active, last_login, created_at
FROM users
WHERE id = ?
    `).get(decoded.userId);

    if (!user || user.is_active !== 1) {
      return res.status(401).json({ error: 'Invalid or inactive user' });
    }

    req.user = user;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

router.post('/register', async (req, res) => {
  try {
    const { email, password, fullName, role, staffId } = req.body;

    if (!email || !password || !fullName) {
      writeSecurityEvent(email, 'REGISTER_FAILED_MISSING_FIELDS', req.ip, 'Missing email, password, or fullName');
      return res.status(400).json({ error: 'Email, password and fullName required' });
    }

    const normalizedEmail = email.toLowerCase();

    const existingUser = db.prepare('SELECT id FROM users WHERE email = ?').get(normalizedEmail);
    if (existingUser) {
      writeSecurityEvent(normalizedEmail, 'REGISTER_FAILED_DUPLICATE_EMAIL', req.ip, 'Email already registered');
      return res.status(409).json({ error: 'User already exists' });
    }

    const passwordHash = await bcrypt.hash(password, 10);

    const selectedRole = role || 'legal_assistant_clerk';

const selectedRoleRecord = db.prepare(`
  SELECT id FROM roles WHERE name = ?
`).get(selectedRole);

const result = db.prepare(`
  INSERT INTO users (email, password_hash, full_name, role, role_id, staff_id, is_active)
  VALUES (?, ?, ?, ?, ?, ?, 1)
`).run(
  normalizedEmail,
  passwordHash,
  fullName,
  selectedRole,
  selectedRoleRecord ? selectedRoleRecord.id : null,
  staffId || null
);

    const user = db.prepare(`
      SELECT id, email, full_name, role, role_id, staff_id, is_active, created_at
FROM users
      WHERE id = ?
    `).get(result.lastInsertRowid);

    const token = jwt.sign(
  {
    userId: user.id,
    email: user.email,
    role: user.role,
    roleId: user.role_id,
    staffId: user.staff_id
  },
  JWT_SECRET,
  { expiresIn: JWT_EXPIRY }
);

    writeAudit(normalizedEmail, 'SQLITE_AUTH_REGISTER', 'USER', String(user.id), null, user, req.ip);
    writeSecurityEvent(normalizedEmail, 'REGISTER_SUCCESS', req.ip, 'SQLite user registered');

    res.status(201).json({ user, token });
  } catch (error) {
    writeSecurityEvent(req.body && req.body.email, 'REGISTER_ERROR', req.ip, error.message);
    res.status(500).json({ error: error.message });
  }
});

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      writeSecurityEvent(email, 'LOGIN_FAILED_MISSING_FIELDS', req.ip, 'Missing email or password');
      return res.status(400).json({ error: 'Email and password required' });
    }

    const normalizedEmail = email.toLowerCase();
    const userRecord = db.prepare('SELECT * FROM users WHERE email = ?').get(normalizedEmail);

    if (!userRecord) {
      writeSecurityEvent(normalizedEmail, 'LOGIN_FAILED_USER_NOT_FOUND', req.ip, 'No matching SQLite user');
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    if (userRecord.is_active !== 1) {
      writeSecurityEvent(normalizedEmail, 'LOGIN_FAILED_INACTIVE', req.ip, 'Inactive SQLite user');
      return res.status(401).json({ error: 'Account is inactive' });
    }

    const isValidPassword = await bcrypt.compare(password, userRecord.password_hash);

    if (!isValidPassword) {
      writeSecurityEvent(normalizedEmail, 'LOGIN_FAILED_BAD_PASSWORD', req.ip, 'Password mismatch');
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    db.prepare('UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?').run(userRecord.id);

    const safeUser = db.prepare(`
      SELECT id, email, full_name, role, staff_id, is_active, last_login, created_at
      FROM users
      WHERE id = ?
    `).get(userRecord.id);

    const token = jwt.sign(
  {
    userId: safeUser.id,
    email: safeUser.email,
    role: safeUser.role,
    roleId: safeUser.role_id,
    staffId: safeUser.staff_id
  },
  JWT_SECRET,
  { expiresIn: JWT_EXPIRY }
);

    writeAudit(normalizedEmail, 'SQLITE_AUTH_LOGIN', 'USER', String(safeUser.id), null, safeUser, req.ip);
    writeSecurityEvent(normalizedEmail, 'LOGIN_SUCCESS', req.ip, 'SQLite user logged in');

    res.json({ user: safeUser, token });
  } catch (error) {
    writeSecurityEvent(req.body && req.body.email, 'LOGIN_ERROR', req.ip, error.message);
    res.status(500).json({ error: error.message });
  }
});

router.get('/me', authenticateSqliteToken, (req, res) => {
  res.json({ user: req.user });
});

router.post('/logout', authenticateSqliteToken, (req, res) => {
  writeAudit(req.user.email, 'SQLITE_AUTH_LOGOUT', 'USER', String(req.user.id), null, null, req.ip);
  writeSecurityEvent(req.user.email, 'LOGOUT_SUCCESS', req.ip, 'SQLite user logged out');
  res.json({ success: true });
});

module.exports = router;