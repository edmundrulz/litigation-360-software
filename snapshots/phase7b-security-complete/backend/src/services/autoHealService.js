const db = require("../database");

function autoHeal() {

  const repairs = [];

  try {

    // ==========================
    // FIX NULL STATUS
    // ==========================

    const statusFix = db.prepare(`
      UPDATE cases
      SET status = 'NEW'
      WHERE status IS NULL
      OR TRIM(status) = ''
    `).run();

    if (statusFix.changes > 0) {

      repairs.push({
        type: "STATUS_REPAIR",
        repaired: statusFix.changes
      });

    }

    // ==========================
    // FIX EMPTY DESCRIPTION
    // ==========================

    const descriptionFix = db.prepare(`
      UPDATE cases
      SET description = ''
      WHERE description IS NULL
    `).run();

    if (descriptionFix.changes > 0) {

      repairs.push({
        type: "DESCRIPTION_REPAIR",
        repaired: descriptionFix.changes
      });

    }

    return {
      success: true,
      repairs
    };

  } catch (err) {

    return {
      success: false,
      error: err.message
    };

  }

}

module.exports = {
  autoHeal
};