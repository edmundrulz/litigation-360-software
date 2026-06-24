const express = require('express');
const { Invoice } = require('../models');
const authMiddleware = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// GET /api/invoices
router.get('/', authMiddleware, async (req, res) => {
  try {
    const { status, page = 1, limit = 50 } = req.query;
    const offset = (page - 1) * limit;

    const where = {};
    if (status) where.status = status;

    const { count, rows } = await Invoice.findAndCountAll({
      where,
      offset,
      limit: parseInt(limit),
      order: [['invoiceDate', 'DESC']]
    });

    res.json({
      data: rows,
      pagination: { page: parseInt(page), limit: parseInt(limit), total: count }
    });
  } catch (error) {
    logger.error(`Get invoices error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

// POST /api/invoices
router.post('/', authMiddleware, async (req, res) => {
  try {
    const { matterId, clientId, invoiceDate, dueDate, totalAmount } = req.body;

    const invoice = await Invoice.create({
      matterId,
      clientId,
      invoiceDate,
      dueDate,
      totalAmount,
      status: 'draft',
      invoiceNumber: `INV-${Date.now()}`
    });

    logger.info(`Invoice created: ${invoice.id}`);
    res.status(201).json(invoice);
  } catch (error) {
    logger.error(`Create invoice error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;