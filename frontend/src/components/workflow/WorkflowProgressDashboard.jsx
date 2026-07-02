function clampPercent(value) {
  const numeric = Number(value);
  if (!Number.isFinite(numeric)) return 0;
  if (numeric < 0) return 0;
  if (numeric > 100) return 100;
  return Math.round(numeric * 10) / 10;
}

function safeCount(value) {
  const numeric = Number(value);
  if (!Number.isFinite(numeric) || numeric < 0) return 0;
  return Math.round(numeric);
}

export default function WorkflowProgressDashboard({
  title = "Workflow Progress",
  stepLabel = "Step",
  completedCount = 0,
  inProgressCount = 0,
  pendingCount,
  blockedCount = 0,
  totalCount = 0,
  lastUpdated,
  notes = "Progress is calculated from actual page data.",
}) {
  const total = safeCount(totalCount);
  const completed = Math.min(safeCount(completedCount), total);
  const blocked = Math.min(safeCount(blockedCount), Math.max(total - completed, 0));
  const inProgress = Math.min(safeCount(inProgressCount), Math.max(total - completed - blocked, 0));
  const resolvedPending = pendingCount === undefined ? Math.max(total - completed - inProgress - blocked, 0) : Math.min(safeCount(pendingCount), Math.max(total - completed - inProgress - blocked, 0));
  const remaining = Math.max(total - completed, 0);
  const completedPercent = total ? clampPercent((completed / total) * 100) : 0;
  const inProgressPercent = total ? clampPercent((inProgress / total) * 100) : 0;
  const pendingPercent = total ? clampPercent((resolvedPending / total) * 100) : 0;
  const blockedPercent = total ? clampPercent((blocked / total) * 100) : 0;
  const remainingPercent = total ? clampPercent((remaining / total) * 100) : 0;
  const updatedLabel = lastUpdated || new Date().toLocaleString();
  const segmentedBarLabel = "Completed " + completedPercent.toFixed(1) + " percent, in progress " + inProgressPercent.toFixed(1) + " percent, pending " + pendingPercent.toFixed(1) + " percent, blocked " + blockedPercent.toFixed(1) + " percent";

  return (
    <section className="workflow-progress-dashboard" aria-label={title}>
      <div className="workflow-progress-dashboard-header">
        <div>
          <p className="workflow-progress-dashboard-kicker">{stepLabel}</p>
          <h3>{title}</h3>
          <p>{notes}</p>
        </div>
        <div className="workflow-progress-dashboard-total">
          <strong>{completedPercent.toFixed(1)}%</strong>
          <span>{completed} of {total} completed</span>
        </div>
      </div>
      <div className="workflow-progress-dashboard-metrics">
        <div><strong>{completed}</strong><span>Completed work</span><small>{completedPercent.toFixed(1)}%</small></div>
        <div><strong>{remaining}</strong><span>Remaining work</span><small>{remainingPercent.toFixed(1)}%</small></div>
        <div><strong>{total}</strong><span>Total scope</span><small>100.0%</small></div>
        <div><strong>{resolvedPending}</strong><span>Pending items</span><small>{pendingPercent.toFixed(1)}%</small></div>
        <div><strong>{inProgress}</strong><span>In progress</span><small>{inProgressPercent.toFixed(1)}%</small></div>
        <div><strong>{blocked}</strong><span>Blocked / at risk</span><small>{blockedPercent.toFixed(1)}%</small></div>
      </div>
      <div className="workflow-progress-segmented-bar" aria-label={segmentedBarLabel}>
        <span className="complete" style={{ width: completedPercent + "%" }} />
        <span className="in-progress" style={{ width: inProgressPercent + "%" }} />
        <span className="pending" style={{ width: pendingPercent + "%" }} />
        <span className="blocked" style={{ width: blockedPercent + "%" }} />
      </div>
      <div className="workflow-progress-legend">
        <span><i className="complete" /> Completed</span>
        <span><i className="in-progress" /> In progress</span>
        <span><i className="pending" /> Pending</span>
        <span><i className="blocked" /> Blocked / at risk</span>
        <small>Last updated: {updatedLabel}</small>
      </div>
    </section>
  );
}
