const express = require('express');
const { TimeEntry } = require('../models');
const authMiddleware = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// GET /api/time-entries
router.get('/', authMiddleware, async (req, res) => {
  try {
    const { matterId, userId, page = 1, limit = 50 } = req.query;
    const offset = (page - 1) * limit;

    const where = {};
    if (matterId) where.matterId = matterId;
    if (userId) where.userId = userId;

    const { count, rows } = await TimeEntry.findAndCountAll({
      where,
      offset,
      limit: parseInt(limit),
      order: [['dateWorked', 'DESC']]
    });

    res.json({
      data: rows,
      pagination: { page: parseInt(page), limit: parseInt(limit), total: count }
    });
  } catch (error) {
    logger.error(`Get time entries error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

// POST /api/time-entries
router.post('/', authMiddleware, async (req, res) => {
  try {
    const { matterId, hoursWorked, dateWorked, billable, utbmsCode, description } = req.body;

    const timeEntry = await TimeEntry.create({
      matterId,
      userId: req.user.userId,
      hoursWorked,
      dateWorked,
      billable,
      utbmsCode,
      description,
      status: 'draft'
    });

    logger.info(`Time entry created: ${timeEntry.id}`);
    res.status(201).json(timeEntry);
  } catch (error) {
    logger.error(`Create time entry error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;