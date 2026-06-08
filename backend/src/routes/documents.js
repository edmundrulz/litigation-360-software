const express = require('express');
const { Document } = require('../models');
const authMiddleware = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// GET /api/documents
router.get('/', authMiddleware, async (req, res) => {
  try {
    const { matterId, page = 1, limit = 50 } = req.query;
    const offset = (page - 1) * limit;

    const where = {};
    if (matterId) where.matterId = matterId;

    const { count, rows } = await Document.findAndCountAll({
      where,
      offset,
      limit: parseInt(limit),
      order: [['createdAt', 'DESC']]
    });

    res.json({
      data: rows,
      pagination: { page: parseInt(page), limit: parseInt(limit), total: count }
    });
  } catch (error) {
    logger.error(`Get documents error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

// POST /api/documents
router.post('/', authMiddleware, async (req, res) => {
  try {
    const { filename, matterId, fileSize, mimeType, category } = req.body;

    const document = await Document.create({
      filename,
      matterId,
      fileSize,
      mimeType,
      category,
      s3Bucket: process.env.S3_BUCKET || 'litigation-360-docs'
    });

    logger.info(`Document created: ${document.id}`);
    res.status(201).json(document);
  } catch (error) {
    logger.error(`Create document error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;