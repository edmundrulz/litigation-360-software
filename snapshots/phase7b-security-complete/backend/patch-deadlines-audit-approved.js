const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, 'src', 'routes', 'deadlines.js');
const backupDir = path.join(__dirname, 'backup', `deadlines-audit-${new Date().toISOString().replace(/[:.]/g, '-')}`);

fs.mkdirSync(backupDir, { recursive: true });
fs.copyFileSync(file, path.join(backupDir, 'deadlines.js.bak'));

let code = fs.readFileSync(file, 'utf8');

if (!code.includes("require('../utils/auditLogger')")) {
  code = code.replace(
    "const db = require('../database');",
    "const db = require('../database');\nconst auditLog = require('../utils/auditLogger');"
  );
}

if (!code.includes("action: 'CREATE_DEADLINE'")) {
  code = code.replace(
`    const result = db.prepare(
      'INSERT INTO deadlines (title, deadline_date, case_id, reminder_days, notes) VALUES (?, ?, ?, ?, ?)'
    ).run(title, deadline_date, case_id, reminder_days, notes);
    res.json({ id: result.lastInsertRowid });`,
`    const result = db.prepare(
      'INSERT INTO deadlines (title, deadline_date, case_id, reminder_days, notes) VALUES (?, ?, ?, ?, ?)'
    ).run(title, deadline_date, case_id, reminder_days, notes);

    const newDeadline = {
      id: result.lastInsertRowid,
      title,
      deadline_date,
      case_id,
      reminder_days,
      notes
    };

    auditLog({
      userEmail: 'system',
      action: 'CREATE_DEADLINE',
      entityType: 'DEADLINE',
      entityId: String(result.lastInsertRowid),
      oldValue: null,
      newValue: newDeadline,
      ipAddress: req.ip
    });

    res.json({ id: result.lastInsertRowid });`
  );
}

if (!code.includes("action: 'UPDATE_DEADLINE'")) {
  code = code.replace(
`  try {
    const { title, deadline_date, case_id, reminder_days, notes } = req.body;
    db.prepare(
      'UPDATE deadlines SET title = ?, deadline_date = ?, case_id = ?, reminder_days = ?, notes = ? WHERE id = ?'
    ).run(title, deadline_date, case_id, reminder_days, notes, req.params.id);
    res.json({ success: true });`,
`  try {
    const existingDeadline = db.prepare('SELECT * FROM deadlines WHERE id = ?').get(req.params.id);

    if (!existingDeadline) {
      return res.status(404).json({ error: 'Deadline not found' });
    }

    const { title, deadline_date, case_id, reminder_days, notes } = req.body;
    db.prepare(
      'UPDATE deadlines SET title = ?, deadline_date = ?, case_id = ?, reminder_days = ?, notes = ? WHERE id = ?'
    ).run(title, deadline_date, case_id, reminder_days, notes, req.params.id);

    const updatedDeadline = {
      id: req.params.id,
      title,
      deadline_date,
      case_id,
      reminder_days,
      notes
    };

    auditLog({
      userEmail: 'system',
      action: 'UPDATE_DEADLINE',
      entityType: 'DEADLINE',
      entityId: String(req.params.id),
      oldValue: existingDeadline,
      newValue: updatedDeadline,
      ipAddress: req.ip
    });

    res.json({ success: true });`
  );
}

if (!code.includes("action: 'DELETE_DEADLINE'")) {
  code = code.replace(
`  try {
    db.prepare('DELETE FROM deadlines WHERE id = ?').run(req.params.id);
    res.json({ success: true });`,
`  try {
    const existingDeadline = db.prepare('SELECT * FROM deadlines WHERE id = ?').get(req.params.id);

    if (!existingDeadline) {
      return res.status(404).json({ error: 'Deadline not found' });
    }

    auditLog({
      userEmail: 'system',
      action: 'DELETE_DEADLINE',
      entityType: 'DEADLINE',
      entityId: String(req.params.id),
      oldValue: existingDeadline,
      newValue: null,
      ipAddress: req.ip
    });

    db.prepare('DELETE FROM deadlines WHERE id = ?').run(req.params.id);
    res.json({ success: true });`
  );
}

fs.writeFileSync(file, code, 'utf8');

console.log('Deadlines audit patch complete.');
console.log('Backup saved to:', backupDir);