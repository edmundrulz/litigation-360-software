const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const logger = require('./utils/logger');
const { sequelize } = require('./models');

// Import routes
const authRoutes = require('./routes/auth');
const clientRoutes = require('./routes/clients');
const matterRoutes = require('./routes/matters');
const documentRoutes = require('./routes/documents');
const timeEntryRoutes = require('./routes/timeEntries');
const invoiceRoutes = require('./routes/invoices');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Too many requests from this IP, please try again later.'
});
app.use('/api/', limiter);

// Request logging
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path}`);
  next();
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/clients', clientRoutes);
app.use('/api/matters', matterRoutes);
app.use('/api/documents', documentRoutes);
app.use('/api/time-entries', timeEntryRoutes);
app.use('/api/invoices', invoiceRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

// Error handling middleware
app.use((err, req, res, next) => {
  logger.error(`Error: ${err.message}`);
  res.status(err.status || 500).json({
    error: err.message,
    status: err.status || 500
  });
});

// Database sync and server start
sequelize.sync({ alter: process.env.NODE_ENV === 'development' })
  .then(() => {
    logger.info('Database synchronized');
    app.listen(PORT, () => {
      logger.info(`Server running on port ${PORT}`);
    });
  })
  .catch(err => {
    logger.error(`Database sync error: ${err.message}`);
    process.exit(1);
  });

module.exports = app;