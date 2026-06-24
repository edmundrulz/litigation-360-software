const { getUpcomingCourtEvents, getCourtEvents } = require("./courtOperationsEngine");
const { getDocuments } = require("./documentLifecycleEngine");
const { getWorkflows } = require("./workflowEngine");
const { createNotification } = require("./notificationService");

const courtRegistry = new Map();

const navigationMetrics = {
  courtsRegistered: 0,
  travelPlansGenerated: 0,
  readinessChecksGenerated: 0,
  dashboardGenerated: 0,
  travelRiskAlerts: 0,
  missingCourtLocations: 0,
  lastGeneratedAt: null
};

function seedDefaultCourts() {
  // PHASE_10K_PERKESO_INDUSTRIAL_COURT_PATCH_START
  registerCourt({
    courtName: "Industrial Court of Malaysia Kuala Lumpur",
    address: "Level 14, Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur",
    latitude: 3.1649,
    longitude: 101.7156,
    parkingNotes: "Wisma PERKESO / Jalan Tun Razak area. Allow additional time for parking, lift access, court floor registration, and security screening.",
    entryNotes: "Industrial Court KL is at Level 14, Wisma PERKESO. Confirm courtroom/mention room before departure.",
    securityNotes: "Bring IC/passport, firm ID if available, appointment/cause list details, and relevant court papers.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "Mahkamah Perusahaan Malaysia Kuala Lumpur",
    address: "Level 14, Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur",
    latitude: 3.1649,
    longitude: 101.7156,
    parkingNotes: "Same location as Industrial Court of Malaysia Kuala Lumpur. Treat as court appearance location.",
    entryNotes: "Use this Malay-name alias so searches for Mahkamah Perusahaan also match.",
    securityNotes: "Confirm proceeding details, e-Mention/physical attendance requirement, and assigned court room.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "PERKESO Wilayah Persekutuan Kuala Lumpur",
    address: "Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur",
    latitude: 3.1649,
    longitude: 101.7156,
    parkingNotes: "Allow extra time for Jalan Tun Razak traffic and building parking.",
    entryNotes: "Useful for PERKESO KL office visits, employment/social security matters, and related filings.",
    securityNotes: "Bring appointment details, company/claimant documents, identification, and matter reference.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 40
  });

  registerCourt({
    courtName: "PERKESO Headquarters Jalan Ampang",
    address: "Menara PERKESO, 281, Jalan Ampang, 50538 Kuala Lumpur",
    latitude: 3.1595,
    longitude: 101.7470,
    parkingNotes: "Jalan Ampang can be congested. Allow extra time for parking and reception registration.",
    entryNotes: "Use this for PERKESO headquarters / SOCSO head office visits.",
    securityNotes: "Bring appointment details, identification, and relevant supporting documents.",
    defaultTravelMinutes: 65,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "SOCSO Headquarters Jalan Ampang",
    address: "Menara PERKESO, 281, Jalan Ampang, 50538 Kuala Lumpur",
    latitude: 3.1595,
    longitude: 101.7470,
    parkingNotes: "Same as PERKESO Headquarters Jalan Ampang. SOCSO is the English equivalent reference.",
    entryNotes: "Alias entry so SOCSO searches route to Menara PERKESO.",
    securityNotes: "Bring appointment details, identification, and relevant supporting documents.",
    defaultTravelMinutes: 65,
    defaultBufferMinutes: 45
  });
  // PHASE_10K_PERKESO_INDUSTRIAL_COURT_PATCH_END
  registerCourt({
    courtName: "Shah Alam High Court",
    address: "Shah Alam, Selangor",
    latitude: 3.0738,
    longitude: 101.5183,
    parkingNotes: "Allow extra time for parking and security screening.",
    entryNotes: "Arrive early for registration and file check.",
    defaultTravelMinutes: 45,
    defaultBufferMinutes: 30
  });

  registerCourt({
    courtName: "Kuala Lumpur High Court",
    address: "Kuala Lumpur Court Complex, Jalan Duta, Kuala Lumpur",
    latitude: 3.1670,
    longitude: 101.6650,
    parkingNotes: "High congestion area. Prefer early arrival.",
    entryNotes: "Security screening queues may be long.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "Petaling Jaya Court",
    address: "Petaling Jaya, Selangor",
    latitude: 3.1073,
    longitude: 101.6067,
    parkingNotes: "Parking may be limited during morning sessions.",
    entryNotes: "Confirm courtroom before arrival.",
    defaultTravelMinutes: 30,
    defaultBufferMinutes: 25
  });
}

function registerCourt({
  courtName,
  address,
  latitude = null,
  longitude = null,
  parkingNotes = null,
  entryNotes = null,
  securityNotes = null,
  defaultTravelMinutes = 45,
  defaultBufferMinutes = 30
} = {}) {
  if (!courtName) throw new Error("courtName is required");

  const existing = courtRegistry.get(courtName);

  const court = {
    courtName,
    address: address || existing?.address || null,
    latitude: latitude ?? existing?.latitude ?? null,
    longitude: longitude ?? existing?.longitude ?? null,
    parkingNotes: parkingNotes || existing?.parkingNotes || null,
    entryNotes: entryNotes || existing?.entryNotes || null,
    securityNotes: securityNotes || existing?.securityNotes || null,
    defaultTravelMinutes: Number(defaultTravelMinutes || existing?.defaultTravelMinutes || 45),
    defaultBufferMinutes: Number(defaultBufferMinutes || existing?.defaultBufferMinutes || 30),
    updatedAt: new Date().toISOString(),
    createdAt: existing?.createdAt || new Date().toISOString()
  };

  courtRegistry.set(courtName, court);

  if (!existing) navigationMetrics.courtsRegistered += 1;
  return court;
}

function getCourt(courtName) {
  return courtRegistry.get(courtName) || null;
}

function listCourts() {
  return Array.from(courtRegistry.values()).sort((a, b) => a.courtName.localeCompare(b.courtName));
}

function parseCourtDateTime(courtEvent) {
  const base = new Date(courtEvent.eventDate);
  if (courtEvent.eventTime && /^\d{2}:\d{2}/.test(courtEvent.eventTime)) {
    const [h, m] = courtEvent.eventTime.split(":").map(Number);
    base.setHours(h, m, 0, 0);
  }
  return base;
}

function formatTime(date) {
  return date.toISOString();
}

function riskFromTravel(courtEvent, travelMinutes, bufferMinutes) {
  const day = parseCourtDateTime(courtEvent).getDay();
  const eventHour = parseCourtDateTime(courtEvent).getHours();

  let pressure = 0;
  if (eventHour >= 8 && eventHour <= 10) pressure += 25;
  if (day === 1 || day === 5) pressure += 15;
  if (travelMinutes >= 60) pressure += 20;
  if (bufferMinutes < 30) pressure += 20;

  if (pressure >= 55) return "HIGH";
  if (pressure >= 30) return "MEDIUM";
  return "LOW";
}

function createTravelPlanForCourtEvent(courtEventId, options = {}) {
  const allCourtEvents = getCourtEvents({ limit: 500 });
  const courtEvent = allCourtEvents.find(c => c.id === courtEventId);

  if (!courtEvent) {
    return { ok: false, error: "Court event not found" };
  }

  let court = getCourt(courtEvent.courtName);
  if (!court) {
    navigationMetrics.missingCourtLocations += 1;
    court = registerCourt({
      courtName: courtEvent.courtName,
      address: courtEvent.courtAddress || "Address not recorded",
      defaultTravelMinutes: options.travelMinutes || 45,
      defaultBufferMinutes: options.bufferMinutes || 30
    });
  }

  const travelMinutes = Number(options.travelMinutes || court.defaultTravelMinutes || 45);
  const bufferMinutes = Number(options.bufferMinutes || court.defaultBufferMinutes || 30);
  const arrivalBufferBeforeCourtMinutes = Number(options.arrivalBufferBeforeCourtMinutes || 30);

  const courtDateTime = parseCourtDateTime(courtEvent);
  const arrivalTarget = new Date(courtDateTime.getTime() - arrivalBufferBeforeCourtMinutes * 60000);
  const recommendedDeparture = new Date(arrivalTarget.getTime() - (travelMinutes + bufferMinutes) * 60000);

  const travelRisk = riskFromTravel(courtEvent, travelMinutes, bufferMinutes);

  if (travelRisk === "HIGH") {
    navigationMetrics.travelRiskAlerts += 1;
    createNotification({
      title: "High Court Travel Risk",
      message: `High travel risk detected for ${courtEvent.courtName}.`,
      level: "WARNING",
      source: "COURT_NAVIGATION",
      eventType: "COURT_TRAVEL_RISK",
      matterId: courtEvent.matterId,
      payload: { courtEventId: courtEvent.id, travelRisk }
    });
  }

  const plan = {
    id: `TRV-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    courtName: courtEvent.courtName,
    courtAddress: court.address || courtEvent.courtAddress,
    courtDateTime: formatTime(courtDateTime),
    estimatedTravelMinutes: travelMinutes,
    bufferMinutes,
    arrivalTarget: formatTime(arrivalTarget),
    recommendedDeparture: formatTime(recommendedDeparture),
    travelRisk,
    parkingNotes: court.parkingNotes,
    entryNotes: court.entryNotes,
    securityNotes: court.securityNotes,
    generatedAt: new Date().toISOString()
  };

  navigationMetrics.travelPlansGenerated += 1;
  navigationMetrics.lastGeneratedAt = new Date().toISOString();

  return { ok: true, plan };
}

function checkCourtReadinessForMatter(matterId) {
  const courtEvents = getCourtEvents({ limit: 500, matterId });
  const documents = getDocuments({ limit: 500, matterId });
  const workflows = getWorkflows({ limit: 500 }).filter(w => w.payload?.matterId === matterId || w.context?.matterId === matterId);
  const courtTasks = [];
  const upcomingCourtEvents = getUpcomingCourtEvents(30).filter(c => c.matterId === matterId);

  const documentsReady = documents.length > 0 && documents.some(d => ["APPROVED", "FILED", "REVIEW"].includes(d.state));
  const courtBundleReady = documents.some(d => String(d.documentType || "").toUpperCase().includes("BUNDLE") || ["APPROVED", "FILED"].includes(d.state));
  const preparationWorkflowActive = workflows.some(w => w.workflowType === "COURT_DATE_PREPARATION" && ["ACTIVE", "COMPLETED"].includes(w.status));
  const travelPlanReady = upcomingCourtEvents.length > 0;
  const attendanceConfirmed = courtEvents.some(c => !!c.assignedTo);

  const missing = [];
  if (!documentsReady) missing.push("Documents not ready or not linked.");
  if (!courtBundleReady) missing.push("Court bundle/readiness document not confirmed.");
  if (!preparationWorkflowActive) missing.push("Court preparation workflow not active or completed.");
  if (!travelPlanReady) missing.push("No upcoming court travel plan basis found.");
  if (!attendanceConfirmed) missing.push("Court attendance not assigned.");

  const score = Math.max(0, 100 - missing.length * 20);
  const status = score >= 80 ? "READY" : score >= 50 ? "ATTENTION" : "NOT_READY";

  navigationMetrics.readinessChecksGenerated += 1;
  navigationMetrics.lastGeneratedAt = new Date().toISOString();

  if (status === "NOT_READY") {
    createNotification({
      title: `Court Readiness Not Ready: ${matterId}`,
      message: missing.join(" "),
      level: "WARNING",
      source: "COURT_NAVIGATION",
      eventType: "COURT_READINESS_NOT_READY",
      matterId,
      payload: { score, missing }
    });
  }

  return {
    matterId,
    status,
    score,
    checks: {
      documentsReady,
      courtBundleReady,
      preparationWorkflowActive,
      travelPlanReady,
      attendanceConfirmed
    },
    missing,
    upcomingCourtEvents: upcomingCourtEvents.length,
    generatedAt: new Date().toISOString()
  };
}

function generateNavigationDashboard() {
  const upcoming = getUpcomingCourtEvents(30);
  const travelPlans = [];
  const readiness = [];

  for (const event of upcoming.slice(0, 25)) {
    const plan = createTravelPlanForCourtEvent(event.id);
    if (plan.ok) travelPlans.push(plan.plan);

    if (event.matterId) readiness.push(checkCourtReadinessForMatter(event.matterId));
  }

  navigationMetrics.dashboardGenerated += 1;
  navigationMetrics.lastGeneratedAt = new Date().toISOString();

  const highRiskTravel = travelPlans.filter(p => p.travelRisk === "HIGH").length;
  const notReady = readiness.filter(r => r.status === "NOT_READY").length;

  return {
    module: "Court Navigation Intelligence",
    status: highRiskTravel > 0 || notReady > 0 ? "ATTENTION" : "HEALTHY",
    upcomingCourtEvents: upcoming.length,
    travelPlans,
    readiness,
    highRiskTravel,
    notReady,
    generatedAt: navigationMetrics.lastGeneratedAt
  };
}

function getNavigationHealth() {
  const dashboard = generateNavigationDashboard();
  return {
    module: "Court Navigation Intelligence",
    status: dashboard.status,
    courtsRegistered: courtRegistry.size,
    travelPlansGenerated: navigationMetrics.travelPlansGenerated,
    readinessChecksGenerated: navigationMetrics.readinessChecksGenerated,
    dashboardGenerated: navigationMetrics.dashboardGenerated,
    travelRiskAlerts: navigationMetrics.travelRiskAlerts,
    missingCourtLocations: navigationMetrics.missingCourtLocations,
    lastGeneratedAt: navigationMetrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getNavigationMetrics() {
  return { ...navigationMetrics, courtsRegistered: courtRegistry.size, timestamp: new Date().toISOString() };
}

function resetNavigationForTestOnly() {
  courtRegistry.clear();
  navigationMetrics.courtsRegistered = 0;
  navigationMetrics.travelPlansGenerated = 0;
  navigationMetrics.readinessChecksGenerated = 0;
  navigationMetrics.dashboardGenerated = 0;
  navigationMetrics.travelRiskAlerts = 0;
  navigationMetrics.missingCourtLocations = 0;
  navigationMetrics.lastGeneratedAt = null;
  
function registerMalaysiaCourtAndAgencyLocations() {
  registerCourt({
    courtName: "Industrial Court Kuala Lumpur",
    address: "Level 14, Wisma PERKESO, No.155 Jalan Tun Razak, Kuala Lumpur",
    latitude: 3.1652,
    longitude: 101.7183,
    parkingNotes: "Allow extra time for Jalan Tun Razak congestion, parking, lift access, and security screening.",
    entryNotes: "Proceed to Wisma PERKESO. Industrial Court Kuala Lumpur is listed at Level 14.",
    securityNotes: "Bring identification and court-related documents.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "PERKESO Kuala Lumpur",
    address: "Wisma PERKESO, No.155 Jalan Tun Razak, Kuala Lumpur",
    latitude: 3.1652,
    longitude: 101.7183,
    parkingNotes: "Jalan Tun Razak traffic can be heavy during peak hours.",
    entryNotes: "Confirm department/counter before arrival.",
    securityNotes: "Bring identification and appointment/reference details.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "PERKESO Headquarters",
    address: "Menara PERKESO, 281 Jalan Ampang, Kuala Lumpur",
    latitude: 3.1606,
    longitude: 101.7467,
    parkingNotes: "Allow additional time for Jalan Ampang traffic and parking.",
    entryNotes: "Confirm floor, department, and appointment before arrival.",
    securityNotes: "Bring identification and appointment/reference details.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "Menara PERKESO Jalan Ampang",
    address: "Menara PERKESO, 281 Jalan Ampang, Kuala Lumpur",
    latitude: 3.1606,
    longitude: 101.7467,
    parkingNotes: "Allow additional time for Jalan Ampang traffic and parking.",
    entryNotes: "Confirm floor, department, and appointment before arrival.",
    securityNotes: "Bring identification and appointment/reference details.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });
}
seedDefaultCourts();
registerMalaysiaCourtAndAgencyLocations();
}


function registerMalaysiaCourtAndAgencyLocations() {
  registerCourt({
    courtName: "Industrial Court Kuala Lumpur",
    address: "Level 14, Wisma PERKESO, No.155 Jalan Tun Razak, Kuala Lumpur",
    latitude: 3.1652,
    longitude: 101.7183,
    parkingNotes: "Allow extra time for Jalan Tun Razak congestion, parking, lift access, and security screening.",
    entryNotes: "Proceed to Wisma PERKESO. Industrial Court Kuala Lumpur is listed at Level 14.",
    securityNotes: "Bring identification and court-related documents.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "PERKESO Kuala Lumpur",
    address: "Wisma PERKESO, No.155 Jalan Tun Razak, Kuala Lumpur",
    latitude: 3.1652,
    longitude: 101.7183,
    parkingNotes: "Jalan Tun Razak traffic can be heavy during peak hours.",
    entryNotes: "Confirm department/counter before arrival.",
    securityNotes: "Bring identification and appointment/reference details.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "PERKESO Headquarters",
    address: "Menara PERKESO, 281 Jalan Ampang, Kuala Lumpur",
    latitude: 3.1606,
    longitude: 101.7467,
    parkingNotes: "Allow additional time for Jalan Ampang traffic and parking.",
    entryNotes: "Confirm floor, department, and appointment before arrival.",
    securityNotes: "Bring identification and appointment/reference details.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "Menara PERKESO Jalan Ampang",
    address: "Menara PERKESO, 281 Jalan Ampang, Kuala Lumpur",
    latitude: 3.1606,
    longitude: 101.7467,
    parkingNotes: "Allow additional time for Jalan Ampang traffic and parking.",
    entryNotes: "Confirm floor, department, and appointment before arrival.",
    securityNotes: "Bring identification and appointment/reference details.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });
}
seedDefaultCourts();
registerMalaysiaCourtAndAgencyLocations();

module.exports = {
  registerCourt,
  getCourt,
  listCourts,
  createTravelPlanForCourtEvent,
  checkCourtReadinessForMatter,
  generateNavigationDashboard,
  getNavigationHealth,
  getNavigationMetrics,
  resetNavigationForTestOnly
};


