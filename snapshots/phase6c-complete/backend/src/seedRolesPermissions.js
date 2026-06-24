const db = require('./database');

console.log('🌱 Starting role and permission seeding...');

const roles = [
  ['administrator', 'Full system administrator'],
  ['managing_partner', 'Firm-level management role'],
  ['senior_lawyer', 'Senior lawyer with matter supervision access'],
  ['junior_lawyer', 'Lawyer with assigned matter access'],
  ['legal_assistant_clerk', 'Clerk and legal assistant operational role'],
  ['chambering_student', 'Read-only trainee legal role'],
  ['client', 'External client portal role'],
  ['guest', 'Minimal access guest role']
];

const permissions = [
  ['VIEW_CLIENTS', 'View clients'],
  ['CREATE_CLIENTS', 'Create clients'],
  ['EDIT_CLIENTS', 'Edit clients'],
  ['DELETE_CLIENTS', 'Delete clients'],

  ['VIEW_MATTERS', 'View matters'],
  ['CREATE_MATTERS', 'Create matters'],
  ['EDIT_MATTERS', 'Edit matters'],
  ['DELETE_MATTERS', 'Delete matters'],
  ['ASSIGN_MATTERS', 'Assign matters'],
  ['CLOSE_MATTERS', 'Close matters'],

  ['VIEW_DOCUMENTS', 'View documents'],
  ['UPLOAD_DOCUMENTS', 'Upload documents'],
  ['EDIT_DOCUMENTS', 'Edit documents'],
  ['DELETE_DOCUMENTS', 'Delete documents'],
  ['DOWNLOAD_DOCUMENTS', 'Download documents'],

  ['VIEW_DEADLINES', 'View deadlines'],
  ['CREATE_DEADLINES', 'Create deadlines'],
  ['EDIT_DEADLINES', 'Edit deadlines'],
  ['DELETE_DEADLINES', 'Delete deadlines'],

  ['VIEW_STAFF', 'View staff'],
  ['CREATE_STAFF', 'Create staff'],
  ['EDIT_STAFF', 'Edit staff'],
  ['DELETE_STAFF', 'Delete staff'],

  ['VIEW_USERS', 'View users'],
  ['CREATE_USERS', 'Create users'],
  ['EDIT_USERS', 'Edit users'],
  ['DELETE_USERS', 'Delete users'],
  ['RESET_PASSWORDS', 'Reset passwords'],

  ['VIEW_BILLING', 'View billing'],
  ['CREATE_INVOICES', 'Create invoices'],
  ['EDIT_INVOICES', 'Edit invoices'],
  ['APPROVE_INVOICES', 'Approve invoices'],

  ['VIEW_AUDIT_LOGS', 'View audit logs'],
  ['VIEW_SECURITY_EVENTS', 'View security events'],
  ['VIEW_BACKUPS', 'View backups'],
  ['CREATE_BACKUPS', 'Create backups'],
  ['RESTORE_BACKUPS', 'Restore backups'],
  ['SYSTEM_CONFIGURATION', 'Change system configuration'],

  ['VIEW_OWN_MATTERS', 'Client can view own matters'],
  ['VIEW_OWN_DOCUMENTS', 'Client can view own documents'],
  ['VIEW_OWN_INVOICES', 'Client can view own invoices'],

  ['VIEW_PUBLIC_DASHBOARD', 'Guest can view public dashboard']
];

const insertRole = db.prepare(`
  INSERT OR IGNORE INTO roles (name, description)
  VALUES (?, ?)
`);

for (const role of roles) {
  insertRole.run(role[0], role[1]);
}

const insertPermission = db.prepare(`
  INSERT OR IGNORE INTO permissions (code, description)
  VALUES (?, ?)
`);

for (const permission of permissions) {
  insertPermission.run(permission[0], permission[1]);
}

const roleCount = db.prepare(`SELECT COUNT(*) AS count FROM roles`).get();
const permissionCount = db.prepare(`SELECT COUNT(*) AS count FROM permissions`).get();

const insertRolePermission = db.prepare(`
  INSERT OR IGNORE INTO role_permissions (role_id, permission_id)
  VALUES (?, ?)
`);

const adminRole = db.prepare(`
  SELECT id FROM roles WHERE name = 'administrator'
`).get();

const allPermissions = db.prepare(`
  SELECT id FROM permissions
`).all();

for (const permission of allPermissions) {
  insertRolePermission.run(adminRole.id, permission.id);
}

const managingPartnerRole = db.prepare(`
  SELECT id FROM roles WHERE name = 'managing_partner'
`).get();

const managingPartnerPermissions = db.prepare(`
  SELECT id FROM permissions
  WHERE code NOT IN ('DELETE_USERS', 'SYSTEM_CONFIGURATION')
`).all();

for (const permission of managingPartnerPermissions) {
  insertRolePermission.run(managingPartnerRole.id, permission.id);
}

const adminPermissionCount = db.prepare(`
  SELECT COUNT(*) AS count
  FROM role_permissions rp
  JOIN roles r ON rp.role_id = r.id
  WHERE r.name = 'administrator'
`).get();

const managingPartnerPermissionCount = db.prepare(`
  SELECT COUNT(*) AS count
  FROM role_permissions rp
  JOIN roles r ON rp.role_id = r.id
  WHERE r.name = 'managing_partner'
`).get();

try {
  const administratorRole = db.prepare(`
    SELECT id
    FROM roles
    WHERE name = 'administrator'
  `).get();

  if (administratorRole) {
    db.prepare(`
      UPDATE users
      SET role_id = ?
      WHERE email = 'admin@litigation360.local'
    `).run(administratorRole.id);
  }
} catch (err) {
  console.log('Admin role assignment skipped:', err.message);
}

let adminUserCheck = null;

try {
  adminUserCheck = db.prepare(`
    SELECT email, role_id
    FROM users
    WHERE email = 'admin@litigation360.local'
  `).get();
} catch (err) {
  console.log('Admin verification skipped:', err.message);
}

console.log('Roles inserted/verified:', roleCount.count);
console.log('Permissions inserted/verified:', permissionCount.count);
console.log('Administrator permissions linked:', adminPermissionCount.count);
console.log('Managing Partner permissions linked:', managingPartnerPermissionCount.count);
console.log('Admin User:', adminUserCheck);
console.log('✅ Step 8 complete');