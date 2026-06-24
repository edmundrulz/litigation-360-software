const express = require("express");
const router = express.Router();

const {
  autoHeal
} = require("../services/autoHealService");

router.get("/", (req, res) => {

  const result = autoHeal();

  res.json({
    executed: true,
    ...result,
    timestamp: new Date().toISOString()
  });

});

module.exports = router;