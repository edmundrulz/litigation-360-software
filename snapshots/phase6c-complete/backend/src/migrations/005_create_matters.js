exports.up = async function(knex) {
  await knex.schema.createTable('clients', t => {
    t.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    t.string('full_name', 255).notNullable();
    t.string('ic_number', 20).unique();
    t.string('passport_number', 30);
    t.string('email', 255);
    t.string('phone', 30);
    t.text('address');
    t.date('date_of_birth');
    t.string('nationality', 50);
    t.boolean('is_active').defaultTo(true);
    t.timestamp('created_at').defaultTo(knex.fn.now());
    t.uuid('created_by').references('users.id');
    t.timestamp('deleted_at');  // soft delete only

    t.index('ic_number');
    t.index('email');
    t.index(knex.raw('lower(full_name)'));  // case-insensitive name search
  });

  await knex.schema.createTable('matters', t => {
    t.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    t.string('reference', 20).unique().notNullable();   // MAT-2026-048
    t.uuid('client_id').references('clients.id').notNullable();
    t.string('matter_type', 100).notNullable();
    t.string('court', 100);
    t.text('description');
    t.string('opposing_party', 255);
    t.string('opposing_counsel', 255);
    t.decimal('estimated_value', 15, 2);
    t.string('priority', 20).defaultTo('normal');      // normal / high / urgent
    t.string('status', 30).defaultTo('intake');        // intake/review/active/hearing/judgment/closed
    t.jsonb('tags').defaultTo('[]');
    t.uuid('senior_lawyer_id').references('users.id');
    t.uuid('junior_lawyer_id').references('users.id').nullable();
    t.string('billing_rate', 50);
    t.text('internal_notes');
    t.date('first_hearing_date');
    t.timestamp('created_at').defaultTo(knex.fn.now());
    t.uuid('created_by').references('users.id');
    t.timestamp('deleted_at');

    t.index('client_id');
    t.index('status');
    t.index('senior_lawyer_id');
    t.index(knex.raw('lower(opposing_party)'));
  });

  // Auto-increment sequence for matter reference numbers
  await knex.raw(`CREATE SEQUENCE matter_seq START 1`);
};

exports.down = async function(knex) {
  await knex.raw('DROP SEQUENCE IF EXISTS matter_seq');
  await knex.schema.dropTableIfExists('matters');
  await knex.schema.dropTableIfExists('clients');
};