# Litigation 360 Phase 8A Database Inventory 
 
Generated on: Wed 17/06/2026 16:16:47.20 
 
## SQLite / Database Files Found 
 
- %%F 
 
## Backend Database References 
 
backend\src\database.js:1:const Database = require('better-sqlite3');
backend\src\database.js:4:const db = new Database(path.join(__dirname, '../litigation360.db'));
backend\src\database.js:156:console.log('✅ Database ready — all tables created');
backend\src\database_BACKUP_1.js:1:const Database = require('better-sqlite3');
backend\src\database_BACKUP_1.js:4:const db = new Database(path.join(__dirname, '../litigation360.db'));
backend\src\database_BACKUP_1.js:77:console.log('✅ Database ready — all tables created');
backend\src\jobs\systemScheduler.js:1:const db = require("../database");
backend\src\models\index.js:5:  process.env.DB_NAME || 'litigation_360',
backend\src\models\index.js:6:  process.env.DB_USER || 'postgres',
backend\src\models\index.js:7:  process.env.DB_PASSWORD || 'postgres',
backend\src\models\index.js:9:    host: process.env.DB_HOST || 'localhost',
backend\src\models\index.js:10:    port: process.env.DB_PORT || 5432,
backend\src\routes\auditLogs.js:3:const db = require('../database');
backend\src\routes\cases.js:4:const db = require('../database');
backend\src\routes\clients.js:5:const db = require('../database');
backend\src\routes\dashboard.js:4:const db = require("../database");
backend\src\routes\dashboard.js:88:        databaseLayer: 95,
backend\src\routes\deadlines.js:4:const db = require('../database');
backend\src\routes\documents.js:4:const db = require('../database');
backend\src\routes\health.js:3:const db = require("../database");
backend\src\routes\health.js:12:      database: dbCheck ? "CONNECTED" : "FAILED",
backend\src\routes\integrityScanner.js:4:const db = require("../database");
backend\src\routes\sqliteAuth.js:4:const db = require('../database');
backend\src\routes\sqliteAuth.js:64:function authenticateSqliteToken(req, res, next) {
backend\src\routes\sqliteAuth.js:146:    writeAudit(normalizedEmail, 'SQLITE_AUTH_REGISTER', 'USER', String(user.id), null, user, req.ip);
backend\src\routes\sqliteAuth.js:147:    writeSecurityEvent(normalizedEmail, 'REGISTER_SUCCESS', req.ip, 'SQLite user registered');
backend\src\routes\sqliteAuth.js:169:      writeSecurityEvent(normalizedEmail, 'LOGIN_FAILED_USER_NOT_FOUND', req.ip, 'No matching SQLite user');
backend\src\routes\sqliteAuth.js:174:      writeSecurityEvent(normalizedEmail, 'LOGIN_FAILED_INACTIVE', req.ip, 'Inactive SQLite user');
backend\src\routes\sqliteAuth.js:205:    writeAudit(normalizedEmail, 'SQLITE_AUTH_LOGIN', 'USER', String(safeUser.id), null, safeUser, req.ip);
backend\src\routes\sqliteAuth.js:206:    writeSecurityEvent(normalizedEmail, 'LOGIN_SUCCESS', req.ip, 'SQLite user logged in');
backend\src\routes\sqliteAuth.js:215:router.get('/me', authenticateSqliteToken, (req, res) => {
backend\src\routes\sqliteAuth.js:219:router.post('/logout', authenticateSqliteToken, (req, res) => {
backend\src\routes\sqliteAuth.js:220:  writeAudit(req.user.email, 'SQLITE_AUTH_LOGOUT', 'USER', String(req.user.id), null, null, req.ip);
backend\src\routes\sqliteAuth.js:221:  writeSecurityEvent(req.user.email, 'LOGOUT_SUCCESS', req.ip, 'SQLite user logged out');
backend\src\routes\staff.js:4:const db = require('../database');
backend\src\routes\systemDiagnostic.js:4:const db = require("../database");
backend\src\routes\systemDiagnostic.js:30:      database: dbCheck ? "CONNECTED" : "FAILED",
backend\src\routes\systemDiagnostic.js:134:          type: "DATABASE",
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\auditLogs.js:3:const db = require('../database');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\cases.js:3:const db = require('../database');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\clients.js:4:const db = require('../database');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\dashboard.js:3:const db = require("../database");
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\dashboard.js:87:        databaseLayer: 95,
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\deadlines.js:3:const db = require('../database');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\documents.js:3:const db = require('../database');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\health.js:3:const db = require("../database");
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\health.js:12:      database: dbCheck ? "CONNECTED" : "FAILED",
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\integrityScanner.js:3:const db = require("../database");
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:4:const db = require('../database');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:64:function authenticateSqliteToken(req, res, next) {
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:146:    writeAudit(normalizedEmail, 'SQLITE_AUTH_REGISTER', 'USER', String(user.id), null, user, req.ip);
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:147:    writeSecurityEvent(normalizedEmail, 'REGISTER_SUCCESS', req.ip, 'SQLite user registered');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:169:      writeSecurityEvent(normalizedEmail, 'LOGIN_FAILED_USER_NOT_FOUND', req.ip, 'No matching SQLite user');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:174:      writeSecurityEvent(normalizedEmail, 'LOGIN_FAILED_INACTIVE', req.ip, 'Inactive SQLite user');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:205:    writeAudit(normalizedEmail, 'SQLITE_AUTH_LOGIN', 'USER', String(safeUser.id), null, safeUser, req.ip);
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:206:    writeSecurityEvent(normalizedEmail, 'LOGIN_SUCCESS', req.ip, 'SQLite user logged in');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:215:router.get('/me', authenticateSqliteToken, (req, res) => {
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:219:router.post('/logout', authenticateSqliteToken, (req, res) => {
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:220:  writeAudit(req.user.email, 'SQLITE_AUTH_LOGOUT', 'USER', String(req.user.id), null, null, req.ip);
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\sqliteAuth.js:221:  writeSecurityEvent(req.user.email, 'LOGOUT_SUCCESS', req.ip, 'SQLite user logged out');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\staff.js:3:const db = require('../database');
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\systemDiagnostic.js:3:const db = require("../database");
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\systemDiagnostic.js:29:      database: dbCheck ? "CONNECTED" : "FAILED",
backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\systemDiagnostic.js:133:          type: "DATABASE",
backend\src\seedRolesPermissions.js:1:const db = require('./database');
backend\src\services\autoHealService.js:1:const db = require("../database");
backend\src\utils\auditLogger.js:1:const db = require('../database');
backend\src\utils\matterNumberGenerator.js:1:const db = require('../database');
 
## NPM Test Result 
 

> test
> jest --runInBand

PASS tests/crud-smoke.test.js
PASS tests/security-routes.test.js
PASS tests/staff.test.js
PASS tests/deadlines.test.js
PASS tests/matters.test.js
PASS tests/documents.test.js
PASS tests/health.test.js
PASS tests/clients.test.js

Test Suites: 8 passed, 8 total
Tests:       26 passed, 26 total
Snapshots:   0 total
Time:        4.649 s, estimated 5 s
Ran all test suites.
