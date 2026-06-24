const express = require('express');
const router = express.Router();
const db = require('../database');
const auditLog = require('../utils/auditLogger');


// GET all staff

router.get('/', (req, res) => {
  try {

    const staff = db.prepare(`
      SELECT *
      FROM staff
      ORDER BY full_name
    `).all();

    res.json(staff);

  } catch (error) {

    res.status(500).json({
      error: error.message
    });

  }
});


// CREATE staff

router.post('/', (req, res) => {

  try {

    const {
      full_name,
      nric,
      email,
      phone,
      role
    } = req.body;


    const result = db.prepare(`
      INSERT INTO staff
      (
        full_name,
        nric,
        email,
        phone,
        role
      )
      VALUES
      (?, ?, ?, ?, ?)
    `).run(
      full_name,
      nric,
      email,
      phone,
      role
    );


    auditLog({
      userEmail: 'system',
      action: 'CREATE_STAFF',
      entityType: 'STAFF',
      entityId: result.lastInsertRowid,
      newValue: {
        full_name,
        email,
        role
      },
      ipAddress: req.ip
    });


    res.json({
      success: true,
      id: result.lastInsertRowid
    });

  } catch (error) {

    res.status(500).json({
      error: error.message
    });

  }

});


// UPDATE staff

router.put('/:id', (req, res) => {

  try {

    const {
      full_name,
      nric,
      email,
      phone,
      role,
      is_active
    } = req.body;


    db.prepare(`
      UPDATE staff
      SET
        full_name = ?,
        nric = ?,
        email = ?,
        phone = ?,
        role = ?,
        is_active = ?
      WHERE id = ?
    `).run(
      full_name,
      nric,
      email,
      phone,
      role,
      is_active,
      req.params.id
    );


    auditLog({
      userEmail: 'system',
      action: 'UPDATE_STAFF',
      entityType: 'STAFF',
      entityId: req.params.id,
      newValue: req.body,
      ipAddress: req.ip
    });


    res.json({
      success: true
    });

  } catch (error) {

    res.status(500).json({
      error: error.message
    });

  }

});


// DELETE staff

router.delete('/:id', (req, res) => {

  try {

    db.prepare(`
      DELETE FROM staff
      WHERE id = ?
    `).run(req.params.id);


    auditLog({
      userEmail: 'system',
      action: 'DELETE_STAFF',
      entityType: 'STAFF',
      entityId: req.params.id,
      ipAddress: req.ip
    });


    res.json({
      success: true
    });

  } catch (error) {

    res.status(500).json({
      error: error.message
    });

  }

});

router.get('/search/:term', (req, res) => {
  try {

    const term = `%${req.params.term}%`;

    const results = db.prepare(`
      SELECT *
      FROM staff
      WHERE
        full_name LIKE ?
        OR email LIKE ?
        OR role LIKE ?
      ORDER BY full_name
    `).all(
      term,
      term,
      term
    );

    res.json(results);

  } catch (error) {

    res.status(500).json({
      error: error.message
    });

  }
});

module.exports = router;