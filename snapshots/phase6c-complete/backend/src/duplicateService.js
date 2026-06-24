const db = require('../db');

// ─── Levenshtein distance for fuzzy name matching ─────────────────────────
function levenshtein(a, b) {
  const m = a.length, n = b.length;
  const dp = Array.from({ length: m + 1 }, (_, i) =>
    Array.from({ length: n + 1 }, (_, j) => (i === 0 ? j : j === 0 ? i : 0))
  );
  for (let i = 1; i <= m; i++)
    for (let j = 1; j <= n; j++)
      dp[i][j] = a[i-1] === b[j-1]
        ? dp[i-1][j-1]
        : 1 + Math.min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]);
  return dp[m][n];
}

function nameSimilarity(a, b) {
  if (!a || !b) return 0;
  a = a.toLowerCase().trim();
  b = b.toLowerCase().trim();
  if (a === b) return 1.0;
  const dist = levenshtein(a, b);
  const maxLen = Math.max(a.length, b.length);
  return Math.max(0, 1 - dist / maxLen);
}

// Normalise IC — strip dashes, spaces
function normaliseIC(ic) {
  return (ic || '').replace(/[-\s]/g, '');
}

// ─── Score a candidate client against the intake data ─────────────────────
function scoreClientMatch(candidate, intake) {
  let score = 0;
  let signals = [];

  // IC exact match — highest weight (near-certainty)
  const icA = normaliseIC(candidate.ic_number);
  const icB = normaliseIC(intake.ic_number);
  if (icA && icB && icA === icB) {
    score += 60; signals.push({ field: 'ic_number', weight: 60, match: 'exact' });
  }

  // Email exact match
  if (candidate.email && intake.email &&
      candidate.email.toLowerCase() === intake.email.toLowerCase()) {
    score += 25; signals.push({ field: 'email', weight: 25, match: 'exact' });
  }

  // Phone match (strip formatting)
  const phoneA = (candidate.phone || '').replace(/[^0-9]/g, '');
  const phoneB = (intake.phone || '').replace(/[^0-9]/g, '');
  if (phoneA.length > 6 && phoneA === phoneB) {
    score += 20; signals.push({ field: 'phone', weight: 20, match: 'exact' });
  }

  // Name fuzzy match
  const nameSim = nameSimilarity(candidate.full_name, intake.full_name);
  if (nameSim > 0.85) {
    const w = Math.round(nameSim * 15);
    score += w; signals.push({ field: 'full_name', weight: w, match: `fuzzy_${(nameSim*100).toFixed(0)}%` });
  }

  // Date of birth match
  if (candidate.date_of_birth && intake.date_of_birth &&
      candidate.date_of_birth === intake.date_of_birth) {
    score += 10; signals.push({ field: 'dob', weight: 10, match: 'exact' });
  }

  return { candidate, score: Math.min(score, 100), signals };
}

// ─── Main duplicate check function ────────────────────────────────────────
async function checkClientDuplicates(intake) {
  const {
    full_name, ic_number, email, phone, date_of_birth
  } = intake;

  // Pull candidates using broad DB-level pre-filter
  const candidates = await db('clients')
    .where(function() {
      if (ic_number) {
        const norm = normaliseIC(ic_number);
        this.orWhereRaw(`REPLACE(ic_number, '-', '') = ?`, [norm]);
      }
      if (email) {
        this.orWhereRaw(`LOWER(email) = ?`, [email.toLowerCase()]);
      }
      if (full_name) {
        const firstWord = full_name.split(' ')[0];
        this.orWhereRaw(`LOWER(full_name) LIKE ?`, [`%${firstWord.toLowerCase()}%`]);
      }
    })
    .where({ deleted_at: null })
    .limit(50);

  // Score each candidate
  const scored = candidates
    .map(c => scoreClientMatch(c, intake))
    .filter(r => r.score >= 50)
    .sort((a, b) => b.score - a.score);

  return {
    hasDuplicates: scored.length > 0,
    matches: scored,
    highConfidence: scored.filter(r => r.score >= 85),
  };
}

// ─── Matter duplicate check ────────────────────────────────────────────────
async function checkMatterDuplicates(intake) {
  const { client_id, matter_type, opposing_party } = intake;

  const existing = await db('matters')
    .where(function() {
      if (client_id) this.orWhere({ client_id });
      if (opposing_party) {
        const opp = opposing_party.split(' ')[0].toLowerCase();
        this.orWhereRaw(`LOWER(opposing_party) LIKE ?`, [`%${opp}%`]);
      }
    })
    .where({ deleted_at: null })
    .whereIn('status', ['intake', 'review', 'active', 'hearing'])
    .limit(20);

  const scored = existing
    .map(m => {
      let score = 0;
      if (client_id && m.client_id === client_id) score += 40;
      if (matter_type && m.matter_type === matter_type) score += 30;
      if (opposing_party && m.opposing_party) {
        const sim = nameSimilarity(opposing_party, m.opposing_party);
        if (sim > 0.7) score += Math.round(sim * 30);
      }
      return { matter: m, score: Math.min(score, 100) };
    })
    .filter(r => r.score >= 50)
    .sort((a, b) => b.score - a.score);

  return {
    hasDuplicates: scored.length > 0,
    matches: scored,
  };
}

// ─── Conflict of interest check ───────────────────────────────────────────
async function checkConflictOfInterest(opposingParty, opposingCounsel) {
  const conflicts = [];

  if (opposingParty) {
    // Check if opposing party is an existing client
    const isClient = await db('clients')
      .whereRaw(`LOWER(full_name) LIKE ?`, [`%${opposingParty.split(' ')[0].toLowerCase()}%`])
      .first();
    if (isClient) {
      conflicts.push({
        type: 'opposing_party_is_client',
        detail: `${opposingParty} appears to be an existing client`,
        severity: 'high',
      });
    }
  }

  if (opposingCounsel) {
    // Check if opposing counsel is a firm lawyer
    const isFirmLawyer = await db('users')
      .join('roles', 'users.role_id', 'roles.id')
      .whereRaw(`LOWER(users.email) LIKE ?`, [`%${opposingCounsel.split(' ')[0].toLowerCase()}%`])
      .whereIn('roles.name', ['senior_lawyer', 'junior_lawyer', 'consultant'])
      .first();
    if (isFirmLawyer) {
      conflicts.push({
        type: 'opposing_counsel_is_firm_member',
        detail: `${opposingCounsel} may be a member of this firm`,
        severity: 'critical',
      });
    }
  }

  return conflicts;
}

module.exports = {
  checkClientDuplicates,
  checkMatterDuplicates,
  checkConflictOfInterest,
  nameSimilarity,
};