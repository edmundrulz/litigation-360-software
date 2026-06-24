app.post("/api/cases/assign", async (req, res) => {
  try {
    const { case_id, staff_id } = req.body;

    // 1. update case with assigned staff
    await db.query(
      "UPDATE cases SET assigned_staff_id = ? WHERE id = ?",
      [staff_id, case_id]
    );

    // 2. optionally increase workload
    await db.query(
      "UPDATE staff SET workload = workload + 1 WHERE id = ?",
      [staff_id]
    );

    res.json({
      success: true,
      message: "Case assigned successfully"
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Assignment failed" });
  }
});