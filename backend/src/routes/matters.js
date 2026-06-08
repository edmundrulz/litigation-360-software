const express = require('express');
const { Matter, Client, Document, TimeEntry } = require('../models');
const authMiddleware = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// GET /api/matters
router.get('/', authMiddleware, async (req, res) => {
  try {
    const { status, page = 1, limit = 50 } = req.query;
    const offset = (page - 1) * limit;

    const where = { firmId: req.user.firmId };
    if (status) where.status = status;

    const { count, rows } = await Matter.findAndCountAll({
      where,
      include: [{ model: Client, attributes: ['firstName', 'lastName'] }],
      offset,
      limit: parseInt(limit),
      order: [['createdAt', 'DESC']]
    });

    res.json({
      data: rows,
      pagination: { page: parseInt(page), limit: parseInt(limit), total: count }
    });
  } catch (error) {
    logger.error(`Get matters error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

// POST /api/matters
router.post('/', authMiddleware, async (req, res) => {
  try {
    const matter = await Matter.create({
      ...req.body,
      firmId: req.user.firmId
    });

    logger.info(`Matter created: ${matter.id}`);
    res.status(201).json(matter);
  } catch (error) {
    logger.error(`Create matter error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/matters/:id
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    const matter = await Matter.findByPk(req.params.id, {
      include: [
        { model: Client },
        { model: Document, limit: 10 },
        { model: TimeEntry, limit: 10 }
      ]
    });

    if (!matter) {
      return res.status(404).json({ error: 'Matter not found' });
    }

    res.json(matter);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// PUT /api/matters/:id
router.put('/:id', authMiddleware, async (req, res) => {
  try {
    const matter = await Matter.findByPk(req.params.id);
    if (!matter) {
      return res.status(404).json({ error: 'Matter not found' });
    }

    await matter.update(req.body);
    logger.info(`Matter updated: ${matter.id}`);
    res.json(matter);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;