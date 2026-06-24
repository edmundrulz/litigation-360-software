INSERT OR IGNORE INTO roles (name, description) VALUES
('administrator', 'Full system administrator'),
('managing_partner', 'Firm-level management role'),
('senior_lawyer', 'Senior lawyer with matter supervision access'),
('junior_lawyer', 'Lawyer with assigned matter access'),
('legal_assistant_clerk', 'Clerk and legal assistant operational role'),
('chambering_student', 'Read-only trainee legal role'),
('client', 'External client portal role'),
('guest', 'Minimal access guest role');

INSERT OR IGNORE INTO permissions (code, description) VALUES
('VIEW_CLIENTS', 'View clients'),
('CREATE_CLIENTS', 'Create clients'),
('EDIT_CLIENTS', 'Edit clients'),
('DELETE_CLIENTS', 'Delete clients'),

('VIEW_MATTERS', 'View matters'),
('CREATE_MATTERS', 'Create matters'),
('EDIT_MATTERS', 'Edit matters'),
('DELETE_MATTERS', 'Delete matters'),
('ASSIGN_MATTERS', 'Assign matters'),
('CLOSE_MATTERS', 'Close matters'),

('VIEW_DOCUMENTS', 'View documents'),
('UPLOAD_DOCUMENTS', 'Upload documents'),
('EDIT_DOCUMENTS', 'Edit documents'),
('DELETE_DOCUMENTS', 'Delete documents'),
('DOWNLOAD_DOCUMENTS', 'Download documents'),

('VIEW_DEADLINES', 'View deadlines'),
('CREATE_DEADLINES', 'Create deadlines'),
('EDIT_DEADLINES', 'Edit deadlines'),
('DELETE_DEADLINES', 'Delete deadlines'),

('VIEW_STAFF', 'View staff'),
('CREATE_STAFF', 'Create staff'),
('EDIT_STAFF', 'Edit staff'),
('DELETE_STAFF', 'Delete staff'),

('VIEW_USERS', 'View users'),
('CREATE_USERS', 'Create users'),
('EDIT_USERS', 'Edit users'),
('DELETE_USERS', 'Delete users'),
('RESET_PASSWORDS', 'Reset passwords'),

('VIEW_BILLING', 'View billing'),
('CREATE_INVOICES', 'Create invoices'),
('EDIT_INVOICES', 'Edit invoices'),
('APPROVE_INVOICES', 'Approve invoices'),

('VIEW_AUDIT_LOGS', 'View audit logs'),
('VIEW_SECURITY_EVENTS', 'View security events'),
('VIEW_BACKUPS', 'View backups'),
('CREATE_BACKUPS', 'Create backups'),
('RESTORE_BACKUPS', 'Restore backups'),
('SYSTEM_CONFIGURATION', 'Change system configuration'),

('VIEW_OWN_MATTERS', 'Client can view own matters'),
('VIEW_OWN_DOCUMENTS', 'Client can view own documents'),
('VIEW_OWN_INVOICES', 'Client can view own invoices'),

('VIEW_PUBLIC_DASHBOARD', 'Guest can view public dashboard');

INSERT OR IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'administrator';