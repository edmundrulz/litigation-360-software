const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, 'src', 'routes', 'documents.js');
const backupDir = path.join(__dirname, 'backup', `documents-audit-${new Date().toISOString().replace(/[:.]/g, '-')}`);

fs.mkdirSync(backupDir, { recursive: true });
fs.copyFileSync(file, path.join(backupDir, 'documents.js.bak'));

let code = fs.readFileSync(file, 'utf8');

if (!code.includes("require('../utils/auditLogger')")) {
  code = code.replace(
    "const db = require('../database');",
    "const db = require('../database');\nconst auditLog = require('../utils/auditLogger');"
  );
}

if (!code.includes("action: 'CREATE_DOCUMENT'")) {
  code = code.replace(
`    const result = db.prepare(
      'INSERT INTO documents (file_name, case_id, document_type) VALUES (?, ?, ?)'
    ).run(file_name, case_id, document_type);
    res.json({ id: result.lastInsertRowid });`,
`    const result = db.prepare(
      'INSERT INTO documents (file_name, case_id, document_type) VALUES (?, ?, ?)'
    ).run(file_name, case_id, document_type);

    const newDocument = {
      id: result.lastInsertRowid,
      file_name,
      case_id,
      document_type
    };

    auditLog({
      userEmail: 'system',
      action: 'CREATE_DOCUMENT',
      entityType: 'DOCUMENT',
      entityId: String(result.lastInsertRowid),
      oldValue: null,
      newValue: newDocument,
      ipAddress: req.ip
    });

    res.json({ id: result.lastInsertRowid });`
  );
}

if (!code.includes("action: 'DELETE_DOCUMENT'")) {
  code = code.replace(
`  try {
    db.prepare('DELETE FROM documents WHERE id = ?').run(req.params.id);
    res.json({ success: true });`,
`  try {
    const existingDocument = db.prepare('SELECT * FROM documents WHERE id = ?').get(req.params.id);

    if (!existingDocument) {
      return res.status(404).json({ error: 'Document not found' });
    }

    auditLog({
      userEmail: 'system',
      action: 'DELETE_DOCUMENT',
      entityType: 'DOCUMENT',
      entityId: String(req.params.id),
      oldValue: existingDocument,
      newValue: null,
      ipAddress: req.ip
    });

    db.prepare('DELETE FROM documents WHERE id = ?').run(req.params.id);
    res.json({ success: true });`
  );
}

fs.writeFileSync(file, code, 'utf8');

console.log('Documents audit patch complete.');
console.log('Backup saved to:', backupDir);