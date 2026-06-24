const db      = require('../db');
const audit   = require('./auditService');
const dup     = require('./duplicateService');

// ─── Generate matter reference: MAT-YYYY-NNN ──────────────────────────────
async function generateMatterRef() {
  const year = new Date().getFullYear();
  const seq  = await db.raw(`SELECT nextval('matter_seq') AS n`);
  const num  = String(seq.rows[0].n).padStart(3, '0');
  return `MAT-${year}-${num}`;
}

// ─── Create a new matter (full intake flow) ───────────────────────────────
async function createMatter({ clientData, matterData, assignmentData, createdBy, req }) {
  return db.transaction(async trx => {

    // 1. Upsert client (use existing if high-confidence duplicate found)
    let clientId = matterData.existing_client_id;
    if (!clientId) {
      const [client] = await trx('clients').insert({
        full_name:    clientData.full_name,
        ic_number:    clientData.ic_number?.replace(/[-\s]/g, '') || null,
        email:        clientData.email?.toLowerCase() || null,
        phone:        clientData.phone,
        address:      clientData.address,
        date_of_birth: clientData.date_of_birth || null,
        nationality:  clientData.nationality,
        created_by:   createdBy,
      }).returning('id');
      clientId = client.id;
    }

    // 2. Generate reference
    const reference = await generateMatterRef();

    // 3. Insert matter
    const [matter] = await trx('matters').insert({
      reference,
      client_id:         clientId,
      matter_type:       matterData.matter_type,
      court:             matterData.court,
      description:       matterData.description,
      opposing_party:    matterData.opposing_party,
      opposing_counsel:  matterData.opposing_counsel,
      estimated_value:   matterData.estimated_value || null,
      priority:          matterData.priority || 'normal',
      status:            'intake',
      tags:              JSON.stringify(matterData.tags || []),
      senior_lawyer_id:  assignmentData.senior_lawyer_id,
      junior_lawyer_id:  assignmentData.junior_lawyer_id || null,
      billing_rate:      assignmentData.billing_rate,
      internal_notes:    assignmentData.internal_notes,
      first_hearing_date: assignmentData.first_hearing_date || null,
      created_by:        createdBy,
    }).returning('*');

    // 4. Create initial workflow event
    await trx('matter_events').insert({
      matter_id:   matter.id,
      event_type:  'STATUS_CHANGE',
      from_status: null,
      to_status:   'intake',
      created_by:  createdBy,
      notes:       'Matter created via intake form',
    });

    // 5. Audit log
    await audit.log({
      user:       { id: createdBy },
      action:     'MATTER_CREATED',
      resource:   'matters',
      resourceId: matter.id,
      matterRef:  reference,
      newValue:   { reference, matter_type: matter.matter_type, client_id: clientId },
      req,
    });

    return { matter, clientId, reference };
  });
}

// ─── Advance matter through the workflow ──────────────────────────────────
const VALID_TRANSITIONS = {
  intake:    ['review'],
  review:    ['active', 'intake'],
  active:    ['hearing', 'review'],
  hearing:   ['judgment', 'active'],
  judgment:  ['closed', 'active'],
  closed:    [],
};

async function advanceMatterStatus(matterId, newStatus, userId, notes, req) {
  const matter = await db('matters').where({ id: matterId }).first();
  if (!matter) throw new Error('Matter not found');

  const allowed = VALID_TRANSITIONS[matter.status] || [];
  if (!allowed.includes(newStatus)) {
    throw new Error(
      `Cannot transition from '${matter.status}' to '${newStatus}'. Allowed: ${allowed.join(', ')}`
    );
  }

  await db.transaction(async trx => {
    await trx('matters').where({ id: matterId }).update({
      status:     newStatus,
      updated_at: new Date(),
    });

    await trx('matter_events').insert({
      matter_id:   matterId,
      event_type:  'STATUS_CHANGE',
      from_status: matter.status,
      to_status:   newStatus,
      created_by:  userId,
      notes,
    });

    await audit.log({
      user:       { id: userId },
      action:     'MATTER_UPDATED',
      resource:   'matters',
      resourceId: matterId,
      matterRef:  matter.reference,
      oldValue:   { status: matter.status },
      newValue:   { status: newStatus },
      req,
    });
  });
}

module.exports = { createMatter, advanceMatterStatus, generateMatterRef };