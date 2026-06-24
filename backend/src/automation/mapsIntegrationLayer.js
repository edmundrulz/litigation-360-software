const { getCourt, listCourts, createTravelPlanForCourtEvent } = require("./courtNavigationEngine");
const { getCourtEvents } = require("./courtOperationsEngine");

const mapsMetrics = {
  googleLinksGenerated: 0,
  wazeLinksGenerated: 0,
  courtLinksGenerated: 0,
  handoffsGenerated: 0,
  missingCourtLocations: 0,
  lastGeneratedAt: null
};

function touch(metric) {
  mapsMetrics[metric] += 1;
  mapsMetrics.lastGeneratedAt = new Date().toISOString();
}

function enc(value) {
  return encodeURIComponent(String(value || ""));
}

function destinationForCourt(court) {
  if (!court) return "";
  if (court.latitude && court.longitude) return `${court.latitude},${court.longitude}`;
  return court.address || court.courtName;
}

function generateGoogleMapsLink({ destination, origin = "", travelMode = "driving" } = {}) {
  if (!destination) throw new Error("destination is required");
  touch("googleLinksGenerated");
  return `https://www.google.com/maps/dir/?api=1&destination=${enc(destination)}${origin ? `&origin=${enc(origin)}` : ""}&travelmode=${enc(travelMode)}`;
}

function generateWazeLink({ latitude = null, longitude = null, query = null } = {}) {
  touch("wazeLinksGenerated");
  if (latitude && longitude) return `https://waze.com/ul?ll=${enc(latitude + "," + longitude)}&navigate=yes`;
  if (query) return `https://waze.com/ul?q=${enc(query)}&navigate=yes`;
  throw new Error("latitude/longitude or query is required");
}

function generateCourtMapLinks(courtName, origin = "") {
  const court = getCourt(courtName);
  if (!court) {
    mapsMetrics.missingCourtLocations += 1;
    mapsMetrics.lastGeneratedAt = new Date().toISOString();
    return { ok: false, error: "Court not found in registry", courtName };
  }

  touch("courtLinksGenerated");
  const destination = destinationForCourt(court);

  return {
    ok: true,
    courtName,
    address: court.address,
    latitude: court.latitude,
    longitude: court.longitude,
    googleMaps: generateGoogleMapsLink({ destination, origin }),
    waze: generateWazeLink({
      latitude: court.latitude,
      longitude: court.longitude,
      query: court.address || court.courtName
    }),
    generatedAt: new Date().toISOString()
  };
}

function generateNavigationHandoffForCourtEvent(courtEventId, options = {}) {
  const courtEvent = getCourtEvents({ limit: 1000 }).find(e => e.id === courtEventId);
  if (!courtEvent) return { ok: false, error: "Court event not found" };

  const travelPlan = createTravelPlanForCourtEvent(courtEventId, options);
  if (!travelPlan.ok) return travelPlan;

  const mapLinks = generateCourtMapLinks(courtEvent.courtName, options.origin || "");
  touch("handoffsGenerated");

  return {
    ok: true,
    courtEventId,
    matterId: courtEvent.matterId,
    courtName: courtEvent.courtName,
    eventType: courtEvent.eventType,
    eventDate: courtEvent.eventDate,
    eventTime: courtEvent.eventTime,
    travelPlan: travelPlan.plan,
    mapLinks,
    checklist: {
      openGoogleMaps: !!mapLinks.googleMaps,
      openWaze: !!mapLinks.waze,
      departBy: travelPlan.plan.recommendedDeparture,
      arriveBy: travelPlan.plan.arrivalTarget,
      confirmParking: !!travelPlan.plan.parkingNotes,
      confirmCourtRoom: !!courtEvent.courtRoom
    },
    generatedAt: new Date().toISOString()
  };
}

function generateMapsDashboard() {
  const courts = listCourts();
  const now = new Date();
  const future = new Date();
  future.setDate(future.getDate() + 30);

  const upcoming = getCourtEvents({ limit: 1000 }).filter(e => {
    const d = new Date(e.eventDate);
    return d >= now && d <= future;
  });

  const handoffs = [];
  for (const event of upcoming.slice(0, 25)) {
    const handoff = generateNavigationHandoffForCourtEvent(event.id);
    if (handoff.ok) handoffs.push(handoff);
  }

  return {
    module: "Maps Integration Layer",
    status: mapsMetrics.missingCourtLocations > 0 ? "ATTENTION" : "HEALTHY",
    registeredCourts: courts.length,
    upcomingCourtEvents: upcoming.length,
    handoffsGenerated: handoffs.length,
    missingCourtLocations: mapsMetrics.missingCourtLocations,
    handoffs,
    generatedAt: new Date().toISOString()
  };
}

function getMapsHealth() {
  const dashboard = generateMapsDashboard();
  return {
    module: "Maps Integration Layer",
    status: dashboard.status,
    registeredCourts: dashboard.registeredCourts,
    upcomingCourtEvents: dashboard.upcomingCourtEvents,
    handoffsGenerated: mapsMetrics.handoffsGenerated,
    googleLinksGenerated: mapsMetrics.googleLinksGenerated,
    wazeLinksGenerated: mapsMetrics.wazeLinksGenerated,
    courtLinksGenerated: mapsMetrics.courtLinksGenerated,
    missingCourtLocations: mapsMetrics.missingCourtLocations,
    lastGeneratedAt: mapsMetrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getMapsMetrics() {
  return { ...mapsMetrics, timestamp: new Date().toISOString() };
}

function resetMapsForTestOnly() {
  mapsMetrics.googleLinksGenerated = 0;
  mapsMetrics.wazeLinksGenerated = 0;
  mapsMetrics.courtLinksGenerated = 0;
  mapsMetrics.handoffsGenerated = 0;
  mapsMetrics.missingCourtLocations = 0;
  mapsMetrics.lastGeneratedAt = null;
}

module.exports = {
  generateGoogleMapsLink,
  generateWazeLink,
  generateCourtMapLinks,
  generateNavigationHandoffForCourtEvent,
  generateMapsDashboard,
  getMapsHealth,
  getMapsMetrics,
  resetMapsForTestOnly
};
