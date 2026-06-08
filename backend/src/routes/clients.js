const express = require('express');
const { Client, Matter } = require('../models');
const authMiddleware = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// GET /api/clients
router.get('/', authMiddleware, async (req, res) => {
  try {
    const { page = 1, limit = 50, search } = req.query;
    const offset = (page - 1) * limit;

    const where = { firmId: req.user.firmId };
    if (search) {
      where[require('sequelize').Op.or] = [
        { firstName: { [require('sequelize').Op.iLike]: `%${search}%` } },
        { lastName: { [require('sequelize').Op.iLike]: `%${search}%` } },
        { email: { [require('sequelize').Op.iLike]: `%${search}%` } }
      ];
    }

    const { count, rows } = await Client.findAndCountAll({
      where,
      offset,
      limit: parseInt(limit),
      order: [['createdAt', 'DESC']]
    });

    res.json({
      data: rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        pages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    logger.error(`Get clients error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

// POST /api/clients
router.post('/', authMiddleware, async (req, res) => {
  try {
    const { firstName, lastName, email, phone, address, city, state, zipCode, clientType } = req.body;

    const client = await Client.create({
      firstName,
      lastName,
      email,
      phone,
      address,
      city,
      state,
      zipCode,
      clientType,
      firmId: req.user.firmId
    });

    logger.info(`Client created: ${client.id}`);
    res.status(201).json(client);
  } catch (error) {
    logger.error(`Create client error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/clients/:id
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    const client = await Client.findByPk(req.params.id, {
      include: [{ model: Matter, as: 'Matters' }]
    });

    if (!client) {
      return res.status(404).json({ error: 'Client not found' });
    }

    res.json(client);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// PUT /api/clients/:id
router.put('/:id', authMiddleware, async (req, res) => {
  try {
    const client = await Client.findByPk(req.params.id);
    if (!client) {
      return res.status(404).json({ error: 'Client not found' });
    }

    await client.update(req.body);
    logger.info(`Client updated: ${client.id}`);
    res.json(client);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;