const express = require("express");
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const QRCode = require("qrcode");
const db = require("../database");
const policy = require("../../../configs/auth-policy.json");
const {
  buildSecurityDisplay,
  identityMatches,
  isOutsideWorkingHours,
  normalizeSqliteUser,
  planAuthentication
} = require("../services/adaptiveAuthService");

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || "your-secret-key";
const JWT_EXPIRY = "24h";

ensureAdaptiveAuthTables();
repairProtectedSystemAccounts();

router.get("/security-display", (req, res) => {
  res.json(buildSecurityDisplay(new Date()));
});

router.post("/start", async (req, res) => {
  try {
    const identity = String(req.body.identity || req.body.email || "").trim().toLowerCase();
    const password = String(req.body.password || "");
    const requestedMethod = normalizeAuthMethod(req.body.method);

    if (!identity || !password) {
      writeSecurityEvent(null, "ADAPTIVE_LOGIN_FAILED_MISSING_FIELDS", req.ip, "Missing identity or password");
      return res.status(400).json({ error: "Identity and password required" });
    }

    const userRecord = findUserByIdentity(identity);

    if (!userRecord) {
      writeSecurityEvent(identity, "ADAPTIVE_LOGIN_FAILED_USER_NOT_FOUND", req.ip, "No matching user");
      return res.status(401).json({ error: "Invalid credentials" });
    }

    if (userRecord.emergency_suspended_at) {
      writeAdaptiveAudit({
        userId: userRecord.id,
        eventType: "PROTECTED_ACCOUNT_EMERGENCY_LOGIN_BLOCKED",
        decision: "blocked",
        riskScore: 100,
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
        details: { reasonRecorded: Boolean(userRecord.emergency_suspension_reason) }
      });
      return res.status(423).json({ error: "This account is under emergency security suspension." });
    }

    enforceProtectedSystemAccount(userRecord);
    const effectiveUserRecord = isProtectedSystemAccount(userRecord)
      ? db.prepare("SELECT * FROM users WHERE id = ?").get(userRecord.id)
      : userRecord;

    const ownerBreakGlassCheck = verifyOwnerBreakGlassCredential(
    req,
    effectiveUserRecord,
    password
  );

  const credentialCheck = ownerBreakGlassCheck.valid
    ? ownerBreakGlassCheck
    : await verifyCredential(
        effectiveUserRecord,
        password,
        requestedMethod
      );

  if (ownerBreakGlassCheck.valid) {
    writeSecurityEvent(
      effectiveUserRecord.id || identity,
      "LEOS_OWNER_BREAK_GLASS_LOGIN",
      req.ip,
      "Protected owner local development recovery used"
    );
  }
    if (!credentialCheck.valid) {
      recordFailedAttempt(effectiveUserRecord.id, req.ip, req.headers["user-agent"]);
      writeSecurityEvent(identity, "ADAPTIVE_LOGIN_FAILED_BAD_PASSWORD", req.ip, "Password mismatch");
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const localDeveloperBuildSession = isLocalProtectedDeveloperBuildSession(
      req,
      effectiveUserRecord,
      credentialCheck
    );

    const user = normalizeSqliteUser(effectiveUserRecord);
    const profile = req.body.identityProfile || {};
    const requestedRoleRaw = String(req.body.requestedRole || req.body.accessRole || "").trim();
    const requestedRole = requestedRoleRaw ? normalizeRoleName(requestedRoleRaw) : "";
    const storedRole = normalizeRoleName(effectiveUserRecord.role);

    if (hasSupplementalIdentityProfile(profile) && !identityMatches(user, profile) && !localDeveloperBuildSession) {
      writeSecurityEvent(identity, "ADAPTIVE_IDENTITY_MATCH_FAILED", req.ip, "Submitted identity profile did not match");
      return res.status(401).json({ error: "Identity details do not match the system record." });
    }

    if (requestedRole && requestedRole !== storedRole) {
      writeAdaptiveAudit({
        userId: user.userId,
        eventType: "ADAPTIVE_ROLE_MISMATCH_BLOCKED",
        decision: "block",
        riskScore: 100,
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
        details: {
          requestedRole,
          storedRole
        }
      });
      return res.status(403).json({
        error: "Selected access role does not match the authorised role stored for this account."
      });
    }

    const failedAttemptsLastHour = countFailedAttempts(user.userId);
    const deviceTrusted = isTrustedDevice(user.userId, req.body.deviceFingerprint);
    let plan = planAuthentication(policy, user, {
      requestedModule: req.body.requestedModule,
      deviceTrusted,
      countryKnown: Boolean(req.headers["x-known-country"]),
      ipRangeKnown: Boolean(req.headers["x-known-network"]),
      failedAttemptsLastHour,
      outsideWorkingHours: isOutsideWorkingHours(new Date()),
      now: new Date()
    });

    /*
     * LEOS_OWNER_BREAK_GLASS_RISK_OVERRIDE
     *
     * A verified protected-owner recovery credential is sufficient
     * for local development access. Adaptive environmental signals
     * remain recorded but cannot block or step-up this owner session.
     *
     * The credential verifier already restricts this path to:
     * - non-production execution;
     * - an existing protected account;
     * - the configured owner username;
     * - a localhost/loopback request;
     * - a valid private scrypt recovery secret.
     */
    if (ownerBreakGlassCheck.valid || localDeveloperBuildSession) {
      const originalPlan = {
        decision: plan.decision,
        riskScore: plan.riskScore,
        assuranceLevel: plan.assuranceLevel,
        reasons: Array.isArray(plan.reasons)
          ? [...plan.reasons]
          : [],
        requiredFactors: Array.isArray(plan.requiredFactors)
          ? [...plan.requiredFactors]
          : []
      };

      plan.decision = "allow";
      plan.riskScore = 0;
      plan.assuranceLevel = 4;
      plan.reasons = [
        localDeveloperBuildSession
          ? "Verified protected developer local build session"
          : "Verified protected owner break-glass development access"
      ];
      plan.requiredFactors = [];
      plan.limitedAccess = false;

      writeAdaptiveAudit({
        userId: user.userId,
        eventType: "LEOS_OWNER_BREAK_GLASS_RISK_OVERRIDE",
        decision: "allow",
        riskScore: 0,
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
        details: {
          originalPlan,
          environment: process.env.NODE_ENV || "development",
          localhostOnly: true,
          persistentBuildSession: localDeveloperBuildSession
        }
      });
    }

    writeAdaptiveAudit({
      userId: user.userId,
      eventType: "ADAPTIVE_LOGIN_PLAN_CREATED",
      decision: plan.decision,
      riskScore: plan.riskScore,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: plan
    });

    if (plan.decision === "block") {
      return res.status(423).json(plan);
    }

    if (plan.decision === "allow") {
      return res.json({
        ...plan,
        token: createToken(effectiveUserRecord, plan.assuranceLevel, { persistent: localDeveloperBuildSession }),
        user: safeUser(effectiveUserRecord)
      });
    }

    const challengeId = createChallenge(user.userId, plan);
    return res.json({
      ...plan,
      challengeId,
      message: "Additional verification required before session is fully trusted."
    });
  } catch (error) {
    writeSecurityEvent(req.body && req.body.identity, "ADAPTIVE_LOGIN_ERROR", req.ip, error.message);
    res.status(500).json({ error: error.message });
  }
});

router.post("/challenge", (req, res) => {
  try {
    const challenge = db.prepare(`
      SELECT *
      FROM auth_challenges
      WHERE id = ? AND status = 'pending'
    `).get(req.body.challengeId);

    if (!challenge) {
      return res.status(404).json({ error: "Challenge not found or already completed." });
    }

    const code = String(req.body.code || "").trim();
    const userRecord = db.prepare("SELECT * FROM users WHERE id = ?").get(challenge.user_id);
    if (userRecord?.emergency_suspended_at) {
      writeAdaptiveAudit({
        userId: challenge.user_id,
        eventType: "PROTECTED_ACCOUNT_EMERGENCY_CHALLENGE_BLOCKED",
        decision: "blocked",
        riskScore: 100,
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
        details: { challengeId: challenge.id }
      });
      return res.status(423).json({ error: "This account is under emergency security suspension." });
    }

    const authenticatorAccepted = userRecord?.qr_secret &&
      userRecord?.authenticator_verified_at &&
      verifyTotpCode(userRecord.qr_secret, code);

    if (!authenticatorAccepted) {
      db.prepare("UPDATE auth_challenges SET failure_count = failure_count + 1 WHERE id = ?").run(challenge.id);
      writeAdaptiveAudit({
        userId: challenge.user_id,
        eventType: "ADAPTIVE_CHALLENGE_FAILED",
        decision: "step_up",
        riskScore: 0,
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
        details: { challengeId: challenge.id }
      });
      return res.status(401).json({ error: "Challenge verification failed." });
    }

    db.prepare(`
      UPDATE auth_challenges
      SET status = 'completed', completed_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `).run(challenge.id);

    db.prepare("UPDATE users SET last_step_up_at = CURRENT_TIMESTAMP, last_login = CURRENT_TIMESTAMP WHERE id = ?").run(challenge.user_id);

    writeAdaptiveAudit({
      userId: challenge.user_id,
      eventType: "ADAPTIVE_CHALLENGE_COMPLETED",
      decision: "allow",
      riskScore: 0,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { challengeId: challenge.id }
    });

    res.json({
      decision: "allow",
      assuranceLevel: 2,
      token: createToken(userRecord, 2),
      user: safeUser(userRecord)
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/admin/users/:userId/authenticator/setup", requireAdminAccess, async (req, res) => {
  try {
    const userRecord = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);
    if (!userRecord) return res.status(404).json({ error: "User not found." });
    if (isProtectedSystemAccount(userRecord) && req.authUser.userId !== userRecord.id) {
      return res.status(403).json({ error: "Protected System / Developer authenticator setup can only be changed by the protected account owner." });
    }

    const secret = generateBase32Secret();
    const label = encodeURIComponent(`LEOS 360:${userRecord.email || userRecord.username || userRecord.id}`);
    const issuer = encodeURIComponent("LEOS 360 Litigation");
    const otpauthUrl = `otpauth://totp/${label}?secret=${secret}&issuer=${issuer}&algorithm=SHA1&digits=6&period=30`;
    const qrDataUrl = await QRCode.toDataURL(otpauthUrl, {
      errorCorrectionLevel: "M",
      margin: 2,
      width: 220
    });

    db.prepare("UPDATE users SET qr_secret = ? WHERE id = ?").run(secret, userRecord.id);

    writeAdaptiveAudit({
      userId: req.authUser.userId,
      eventType: "ADMIN_AUTHENTICATOR_SETUP_CREATED",
      decision: "recorded",
      riskScore: 0,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { targetUserId: userRecord.id }
    });

    res.json({
      userId: userRecord.id,
      label: userRecord.email || userRecord.username,
      otpauthUrl,
      qrDataUrl,
      manualKey: secret
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/admin/users/:userId/authenticator/verify", requireAdminAccess, (req, res) => {
  try {
    const userRecord = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);
    if (!userRecord) return res.status(404).json({ error: "User not found." });
    if (isProtectedSystemAccount(userRecord) && req.authUser.userId !== userRecord.id) {
      return res.status(403).json({ error: "Protected System / Developer authenticator setup can only be verified by the protected account owner." });
    }
    if (!userRecord.qr_secret) return res.status(400).json({ error: "Authenticator setup has not been generated for this user." });

    const code = String(req.body.code || "").trim();
    if (!verifyTotpCode(userRecord.qr_secret, code)) {
      writeAdaptiveAudit({
        userId: req.authUser.userId,
        eventType: "ADMIN_AUTHENTICATOR_VERIFY_FAILED",
        decision: "rejected",
        riskScore: 20,
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
        details: { targetUserId: userRecord.id }
      });
      return res.status(401).json({ error: "Authenticator code did not match. Check the phone time and try again." });
    }

    const factors = new Set(parseList(userRecord.enabled_factors || userRecord.auth_methods_json || "password,otp"));
    factors.add("otp");
    factors.add("qr_approval");
    const enabled = JSON.stringify(Array.from(factors));
    db.prepare("UPDATE users SET enabled_factors = ?, auth_methods_json = ?, authenticator_verified_at = CURRENT_TIMESTAMP WHERE id = ?").run(enabled, enabled, userRecord.id);

    writeAdaptiveAudit({
      userId: req.authUser.userId,
      eventType: "ADMIN_AUTHENTICATOR_ENABLED",
      decision: "recorded",
      riskScore: 0,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { targetUserId: userRecord.id }
    });

    const updated = db.prepare("SELECT * FROM users WHERE id = ?").get(userRecord.id);
    res.json({ user: publicAdminUser(updated) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get("/sessions", (req, res) => {
  const sessions = db.prepare(`
    SELECT
      id,
      user_id,
      email,
      assurance_level,
      status,
      ip_address,
      user_agent,
      started_at,
      last_seen_at,
      expires_at,
      CAST((julianday(COALESCE(forced_logout_at, last_seen_at, CURRENT_TIMESTAMP)) - julianday(started_at)) * 86400 AS INTEGER) AS duration_seconds
    FROM auth_sessions
    ORDER BY last_seen_at DESC
    LIMIT 100
  `).all();

  res.json({ sessions });
});

router.get("/admin/users", requireAdminAccess, (req, res) => {
  repairProtectedSystemAccounts();
  const users = db.prepare("SELECT * FROM users ORDER BY COALESCE(full_name, username, email)").all();
  res.json({ users: users.map(publicAdminUser) });
});

router.post("/admin/users", requireAdminAccess, async (req, res) => {
  try {
    const email = String(req.body.email || "").trim().toLowerCase();
    const username = String(req.body.username || "").trim();
    const password = String(req.body.password || "");

    if (!email || !username || !password) {
      return res.status(400).json({ error: "Full user identity, username, email and password are required." });
    }

    if (findUserByIdentity(email) || findUserByIdentity(username)) {
      return res.status(409).json({ error: "A user with this email or username already exists." });
    }

    const passcodes = Array.isArray(req.body.passcodes) ? req.body.passcodes : parseList(req.body.passcodes);
    const passcodeHashes = [];
    for (const passcode of passcodes) {
      passcodeHashes.push(await bcrypt.hash(String(passcode), 10));
    }

    const userPayload = sanitizeUserPayload({
      full_name: req.body.full_name,
      username,
      email,
      role: req.body.role || "staff",
      phone_number: req.body.phone_number,
      initials: req.body.initials,
      nric_last4: req.body.nric_last4,
      access_status: req.body.access_status || "active",
      password_hash: await bcrypt.hash(password, 10),
      passcode_hashes: JSON.stringify(passcodeHashes),
      enabled_factors: JSON.stringify(Array.isArray(req.body.enabled_factors) ? req.body.enabled_factors : parseList(req.body.enabled_factors || "password,otp")),
      security_phrase: req.body.security_phrase,
      security_colour: req.body.security_colour,
      security_number_code: req.body.security_number_code,
      auth_methods_json: JSON.stringify(Array.isArray(req.body.enabled_factors) ? req.body.enabled_factors : parseList(req.body.enabled_factors || "password,otp")),
      live_monitoring_access: req.body.live_monitoring_access ? 1 : 0,
      protected_account: req.authUser.role === "system" && req.body.protected_account ? 1 : 0,
      break_glass_account: req.authUser.role === "system" && req.body.break_glass_account ? 1 : 0,
      credential_storage_allowed: 1,
      unrestricted_access: normalizeRoleName(req.body.role) === "system" ? 1 : 0
    });

    if (isProtectedSystemAccount(userPayload)) {
      applyProtectedSystemPayload(userPayload);
    }

    const columns = Object.keys(userPayload);
    const placeholders = columns.map(() => "?").join(", ");
    const values = columns.map((column) => userPayload[column]);
    const result = db.prepare(`
      INSERT INTO users (${columns.join(", ")})
      VALUES (${placeholders})
    `).run(...values);

    writeAdaptiveAudit({
      userId: req.authUser.userId,
      eventType: "ADMIN_USER_CREATED",
      decision: "recorded",
      riskScore: 0,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { createdUserId: result.lastInsertRowid, role: userPayload.role }
    });

    const created = db.prepare("SELECT * FROM users WHERE id = ?").get(result.lastInsertRowid);
    res.status(201).json({ user: publicAdminUser(created) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.patch("/admin/users/:userId", requireAdminAccess, async (req, res) => {
  try {
    const existing = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);
    if (!existing) return res.status(404).json({ error: "User not found." });
    enforceProtectedSystemAccount(existing);
    const protectedExisting = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);

    const updatePayload = sanitizeUserPayload({
      full_name: req.body.full_name,
      username: req.body.username,
      email: req.body.email,
      role: req.body.role,
      phone_number: req.body.phone_number,
      initials: req.body.initials,
      nric_last4: req.body.nric_last4,
      access_status: req.body.access_status,
      enabled_factors: req.body.enabled_factors ? JSON.stringify(Array.isArray(req.body.enabled_factors) ? req.body.enabled_factors : parseList(req.body.enabled_factors)) : undefined,
      auth_methods_json: req.body.enabled_factors ? JSON.stringify(Array.isArray(req.body.enabled_factors) ? req.body.enabled_factors : parseList(req.body.enabled_factors)) : undefined,
      security_phrase: req.body.security_phrase,
      security_colour: req.body.security_colour,
      security_number_code: req.body.security_number_code,
      live_monitoring_access: typeof req.body.live_monitoring_access === "undefined" ? undefined : (req.body.live_monitoring_access ? 1 : 0)
    });

    if (req.authUser.role === "system") {
      if (typeof req.body.protected_account !== "undefined") updatePayload.protected_account = req.body.protected_account ? 1 : 0;
      if (typeof req.body.break_glass_account !== "undefined") updatePayload.break_glass_account = req.body.break_glass_account ? 1 : 0;
    }

    if (req.body.password) {
      updatePayload.password_hash = await bcrypt.hash(String(req.body.password), 10);
    }

    if (req.body.passcodes) {
      const passcodes = Array.isArray(req.body.passcodes) ? req.body.passcodes : parseList(req.body.passcodes);
      const passcodeHashes = [];
      for (const passcode of passcodes) {
        passcodeHashes.push(await bcrypt.hash(String(passcode), 10));
      }
      updatePayload.passcode_hashes = JSON.stringify(passcodeHashes);
    }

    const columns = Object.keys(updatePayload);
    if (columns.length === 0) return res.json({ user: publicAdminUser(protectedExisting) });

    if (isProtectedSystemAccount(protectedExisting) && hasProtectedSystemOverride(updatePayload)) {
      writeAdaptiveAudit({
        userId: req.authUser.userId,
        eventType: "PROTECTED_SYSTEM_OVERRIDE_BLOCKED",
        decision: "blocked",
        riskScore: 100,
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
        details: { targetUserId: protectedExisting.id, attemptedFields: columns.filter((column) => !column.includes("hash")) }
      });
      return res.status(403).json({
        error: "Protected System / Developer access is permanent and cannot be revoked, downgraded, disabled or overridden."
      });
    }

    const assignments = columns.map((column) => `${column} = ?`).join(", ");
    db.prepare(`UPDATE users SET ${assignments} WHERE id = ?`).run(...columns.map((column) => updatePayload[column]), req.params.userId);

    writeAdaptiveAudit({
      userId: req.authUser.userId,
      eventType: "ADMIN_USER_UPDATED",
      decision: "recorded",
      riskScore: 0,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { updatedUserId: req.params.userId, fields: columns.filter((column) => !column.includes("hash")) }
    });

    const updated = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);
    res.json({ user: publicAdminUser(updated) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/admin/users/:userId/emergency-suspend", requireBreakGlassAccess, (req, res) => {
  try {
    const userRecord = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);
    if (!userRecord) return res.status(404).json({ error: "User not found." });

    const reason = requireChangeReason(req);
    if (!reason) return res.status(400).json({ error: "Emergency reason is required." });

    db.prepare(`
      UPDATE users
      SET emergency_suspended_at = CURRENT_TIMESTAMP,
          emergency_suspension_reason = ?,
          emergency_suspended_by = ?,
          access_status = 'emergency_suspended'
      WHERE id = ?
    `).run(reason, req.authUser.userId, userRecord.id);
    revokeUserSessions(userRecord.id, "emergency_suspended");
    revokeTrustedDevices(userRecord.id);

    writeAdaptiveAudit({
      userId: req.authUser.userId,
      eventType: "PROTECTED_ACCOUNT_EMERGENCY_SUSPENDED",
      decision: "emergency",
      riskScore: 100,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { targetUserId: userRecord.id, reasonProvided: true }
    });

    res.json({ user: publicAdminUser(db.prepare("SELECT * FROM users WHERE id = ?").get(userRecord.id)) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/admin/users/:userId/emergency-restore", requireBreakGlassAccess, (req, res) => {
  try {
    const userRecord = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);
    if (!userRecord) return res.status(404).json({ error: "User not found." });

    const reason = requireChangeReason(req);
    if (!reason) return res.status(400).json({ error: "Recovery reason is required." });

    db.prepare(`
      UPDATE users
      SET emergency_suspended_at = NULL,
          emergency_suspension_reason = NULL,
          emergency_suspended_by = NULL,
          access_status = 'active',
          is_active = 1
      WHERE id = ?
    `).run(userRecord.id);
    enforceProtectedSystemAccount(db.prepare("SELECT * FROM users WHERE id = ?").get(userRecord.id));

    writeAdaptiveAudit({
      userId: req.authUser.userId,
      eventType: "PROTECTED_ACCOUNT_EMERGENCY_RESTORED",
      decision: "recovered",
      riskScore: 0,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { targetUserId: userRecord.id, reasonProvided: true }
    });

    res.json({ user: publicAdminUser(db.prepare("SELECT * FROM users WHERE id = ?").get(userRecord.id)) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/admin/users/:userId/revoke-sessions", requireBreakGlassAccess, (req, res) => {
  try {
    const userRecord = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);
    if (!userRecord) return res.status(404).json({ error: "User not found." });

    revokeUserSessions(userRecord.id, "emergency_revoked");
    writeAdaptiveAudit({
      userId: req.authUser.userId,
      eventType: "PROTECTED_ACCOUNT_SESSIONS_REVOKED",
      decision: "revoked",
      riskScore: 50,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { targetUserId: userRecord.id }
    });

    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/admin/users/:userId/rotate-credential", requireBreakGlassAccess, async (req, res) => {
  try {
    const userRecord = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);
    if (!userRecord) return res.status(404).json({ error: "User not found." });

    const reason = requireChangeReason(req);
    const password = String(req.body.password || "");
    if (!reason) return res.status(400).json({ error: "Credential rotation reason is required." });
    if (password.length < 10) return res.status(400).json({ error: "New credential must be at least 10 characters." });

    const passcodes = Array.isArray(req.body.passcodes) ? req.body.passcodes : parseList(req.body.passcodes);
    const passcodeHashes = [];
    for (const passcode of passcodes) {
      passcodeHashes.push(await bcrypt.hash(String(passcode), 10));
    }

    db.prepare(`
      UPDATE users
      SET password_hash = ?,
          passcode_hashes = ?,
          credential_rotated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `).run(await bcrypt.hash(password, 10), JSON.stringify(passcodeHashes), userRecord.id);
    revokeUserSessions(userRecord.id, "credential_rotated");

    writeAdaptiveAudit({
      userId: req.authUser.userId,
      eventType: "PROTECTED_ACCOUNT_CREDENTIAL_ROTATED",
      decision: "rotated",
      riskScore: 30,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { targetUserId: userRecord.id, reasonProvided: true, passcodesReplaced: passcodes.length > 0 }
    });

    res.json({ user: publicAdminUser(db.prepare("SELECT * FROM users WHERE id = ?").get(userRecord.id)) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/admin/users/:userId/mfa-reset", requireBreakGlassAccess, (req, res) => {
  try {
    const userRecord = db.prepare("SELECT * FROM users WHERE id = ?").get(req.params.userId);
    if (!userRecord) return res.status(404).json({ error: "User not found." });

    const reason = requireChangeReason(req);
    if (!reason) return res.status(400).json({ error: "MFA reset reason is required." });

    const factors = parseList(userRecord.enabled_factors).filter((factor) => !["otp", "qr", "qr_approval", "totp"].includes(factor));
    const enabled = JSON.stringify(factors.length ? factors : ["password"]);
    db.prepare(`
      UPDATE users
      SET qr_secret = NULL,
          authenticator_verified_at = NULL,
          enabled_factors = ?,
          auth_methods_json = ?,
          mfa_reset_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `).run(enabled, enabled, userRecord.id);
    revokeUserSessions(userRecord.id, "mfa_reset");

    writeAdaptiveAudit({
      userId: req.authUser.userId,
      eventType: "PROTECTED_ACCOUNT_MFA_RESET",
      decision: "reset",
      riskScore: 40,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      details: { targetUserId: userRecord.id, reasonProvided: true }
    });

    res.json({ user: publicAdminUser(db.prepare("SELECT * FROM users WHERE id = ?").get(userRecord.id)) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/audit-event", (req, res) => {
  const eventType = String(req.body.eventType || "APP_ACTIVITY").trim().toUpperCase();
  const details = req.body.details && typeof req.body.details === "object" ? req.body.details : {};

  writeAdaptiveAudit({
    userId: req.body.userId || null,
    eventType,
    decision: req.body.decision || "recorded",
    riskScore: Number(req.body.riskScore || 0),
    ipAddress: req.ip,
    userAgent: req.headers["user-agent"],
    details
  });

  if (details.sessionId) {
    if (["APP_LOGGED_OUT", "APP_EXIT_REQUESTED"].includes(eventType)) {
      db.prepare(`
        UPDATE auth_sessions
        SET status = 'logged_out', last_seen_at = CURRENT_TIMESTAMP, forced_logout_at = CURRENT_TIMESTAMP
        WHERE id = ?
      `).run(details.sessionId);
    } else {
      db.prepare(`
        UPDATE auth_sessions
        SET last_seen_at = CURRENT_TIMESTAMP
        WHERE id = ?
      `).run(details.sessionId);
    }
  }

  res.json({ success: true });
});

router.post("/sessions/:sessionId/force-logout", requireAdminAccess, (req, res) => {
  db.prepare(`
    UPDATE auth_sessions
    SET status = 'forced_logout', forced_logout_at = CURRENT_TIMESTAMP
    WHERE id = ?
  `).run(req.params.sessionId);

  writeAdaptiveAudit({
    userId: null,
    eventType: "ADAPTIVE_FORCE_LOGOUT",
    decision: "restricted",
    riskScore: 0,
    ipAddress: req.ip,
    userAgent: req.headers["user-agent"],
    details: { sessionId: req.params.sessionId }
  });

  res.json({ success: true });
});

function ensureAdaptiveAuthTables() {
  const userColumns = db.prepare("PRAGMA table_info(users)").all().map((column) => column.name);
  const addColumn = (name, definition) => {
    if (!userColumns.includes(name)) db.exec(`ALTER TABLE users ADD COLUMN ${name} ${definition}`);
  };

  addColumn("full_name", "TEXT");
  addColumn("email", "TEXT");
  addColumn("password_hash", "TEXT");
  addColumn("is_active", "INTEGER DEFAULT 1");
  addColumn("access_status", "TEXT DEFAULT 'active'");
  addColumn("role", "TEXT DEFAULT 'staff'");
  addColumn("username", "TEXT");
  addColumn("email_aliases", "TEXT");
  addColumn("initials", "TEXT");
  addColumn("nric_last4", "TEXT");
  addColumn("phone_number", "TEXT");
  addColumn("passcode_hashes", "TEXT");
  addColumn("protected_account", "INTEGER DEFAULT 0");
  addColumn("break_glass_account", "INTEGER DEFAULT 0");
  addColumn("mfa_required", "INTEGER DEFAULT 0");
  addColumn("emergency_suspended_at", "DATETIME");
  addColumn("emergency_suspension_reason", "TEXT");
  addColumn("emergency_suspended_by", "INTEGER");
  addColumn("credential_rotated_at", "DATETIME");
  addColumn("mfa_reset_at", "DATETIME");
  addColumn("unrestricted_access", "INTEGER DEFAULT 0");
  addColumn("credential_storage_allowed", "INTEGER DEFAULT 1");
  addColumn("clearance_level", "INTEGER DEFAULT 1");
  addColumn("step_up_cadence", "TEXT DEFAULT 'monthly'");
  addColumn("last_step_up_at", "DATETIME");
  addColumn("enabled_factors", "TEXT DEFAULT '[\"password\",\"otp\"]'");
  addColumn("auth_methods_json", "TEXT DEFAULT '[\"password\",\"otp\"]'");
  addColumn("security_phrase", "TEXT");
  addColumn("security_colour", "TEXT");
  addColumn("security_number_code", "TEXT");
  addColumn("pattern_hash", "TEXT");
  addColumn("qr_secret", "TEXT");
  addColumn("authenticator_verified_at", "DATETIME");
  addColumn("otp_delivery_target", "TEXT");
  addColumn("live_monitoring_access", "INTEGER DEFAULT 0");

  db.exec(`
    CREATE TABLE IF NOT EXISTS auth_challenges (
      id TEXT PRIMARY KEY,
      user_id INTEGER NOT NULL,
      challenge_type TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'pending',
      expires_at DATETIME NOT NULL,
      completed_at DATETIME,
      failure_count INTEGER NOT NULL DEFAULT 0,
      metadata_json TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS auth_sessions (
      id TEXT PRIMARY KEY,
      user_id INTEGER NOT NULL,
      email TEXT NOT NULL,
      assurance_level INTEGER NOT NULL DEFAULT 1,
      status TEXT NOT NULL DEFAULT 'active',
      ip_address TEXT,
      user_agent TEXT,
      started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      last_seen_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      expires_at DATETIME NOT NULL,
      forced_logout_at DATETIME
    );

    CREATE TABLE IF NOT EXISTS auth_audit_events (
      id TEXT PRIMARY KEY,
      user_id INTEGER,
      event_type TEXT NOT NULL,
      decision TEXT,
      risk_score INTEGER NOT NULL DEFAULT 0,
      ip_address TEXT,
      user_agent TEXT,
      details_json TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS auth_failed_attempts (
      id TEXT PRIMARY KEY,
      user_id INTEGER,
      ip_address TEXT,
      user_agent TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS auth_trusted_devices (
      id TEXT PRIMARY KEY,
      user_id INTEGER NOT NULL,
      device_fingerprint_hash TEXT NOT NULL,
      device_label TEXT,
      first_seen_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      last_seen_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      expires_at DATETIME NOT NULL,
      revoked_at DATETIME,
      UNIQUE(user_id, device_fingerprint_hash)
    );
  `);
}

function createToken(user, assuranceLevel, options = {}) {
  const sessionId = cryptoId();
  const persistent = Boolean(options.persistent);
  const maxAgeMs = persistent ? 30 * 24 * 60 * 60 * 1000 : 10 * 60 * 60 * 1000;
  const expiresAt = new Date(Date.now() + maxAgeMs).toISOString();

  db.prepare(`
    INSERT INTO auth_sessions (id, user_id, email, assurance_level, ip_address, user_agent, expires_at)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `).run(sessionId, user.id, user.email, assuranceLevel, null, null, expiresAt);

  return jwt.sign(
    {
      userId: user.id,
      email: user.email,
      username: user.username,
      role: user.role,
      roleId: user.role_id,
      staffId: user.staff_id,
      assuranceLevel,
      sessionId,
      persistentBuildSession: persistent
    },
    JWT_SECRET,
    { expiresIn: persistent ? "30d" : JWT_EXPIRY }
  );
}

function createChallenge(userId, plan) {
  const id = cryptoId();
  const expiresAt = new Date(Date.now() + 5 * 60 * 1000).toISOString();
  db.prepare(`
    INSERT INTO auth_challenges (id, user_id, challenge_type, expires_at, metadata_json)
    VALUES (?, ?, ?, ?, ?)
  `).run(id, userId, plan.requiredFactors.join("+"), expiresAt, JSON.stringify(plan));
  return id;
}

function countFailedAttempts(userId) {
  const row = db.prepare(`
    SELECT COUNT(*) AS count
    FROM auth_failed_attempts
    WHERE user_id = ? AND created_at >= datetime('now', '-1 hour')
  `).get(userId);
  return row ? row.count : 0;
}

function recordFailedAttempt(userId, ipAddress, userAgent) {
  db.prepare(`
    INSERT INTO auth_failed_attempts (id, user_id, ip_address, user_agent)
    VALUES (?, ?, ?, ?)
  `).run(cryptoId(), userId, ipAddress || null, userAgent || null);
}

function isTrustedDevice(userId, fingerprint) {
  if (!fingerprint) return false;
  const device = db.prepare(`
    SELECT id
    FROM auth_trusted_devices
    WHERE user_id = ? AND device_fingerprint_hash = ? AND revoked_at IS NULL AND expires_at > CURRENT_TIMESTAMP
  `).get(userId, fingerprint);
  return Boolean(device);
}

function safeUser(user) {
  return {
    id: user.id,
    email: user.email,
    username: user.username,
    full_name: user.full_name,
    role: user.role,
    role_id: user.role_id,
    staff_id: user.staff_id,
    is_active: user.is_active
  };
}

function publicAdminUser(user) {
  return {
    id: user.id,
    full_name: user.full_name,
    username: user.username,
    email: user.email,
    email_aliases: parseList(user.email_aliases),
    role: user.role || "staff",
    role_id: user.role_id,
    staff_id: user.staff_id,
    access_status: user.access_status || "active",
    initials: user.initials,
    nric_last4: user.nric_last4,
    phone_number: user.phone_number,
    enabled_factors: parseList(user.enabled_factors),
    auth_methods: parseList(user.auth_methods_json || user.enabled_factors),
    security_phrase: user.security_phrase,
    security_colour: user.security_colour,
    security_number_code: user.security_number_code,
    authenticator_enabled: Boolean(user.qr_secret && user.authenticator_verified_at),
    protected_system: isProtectedSystemAccount(user),
    protected_account: user.protected_account === 1,
    break_glass_account: user.break_glass_account === 1,
    mfa_required: user.mfa_required === 1,
    emergency_suspended: Boolean(user.emergency_suspended_at),
    credential_rotated_at: user.credential_rotated_at,
    mfa_reset_at: user.mfa_reset_at,
    live_monitoring_access: user.live_monitoring_access === 1,
    unrestricted_access: user.unrestricted_access === 1,
    credential_storage_allowed: user.credential_storage_allowed !== 0
  };
}

function getBearerToken(req) {
  const header = String(req.headers.authorization || "");
  if (!header.toLowerCase().startsWith("bearer ")) return "";
  return header.slice(7).trim();
}

function requireAdminAccess(req, res, next) {
  try {
    const token = getBearerToken(req);
    if (!token) return res.status(401).json({ error: "Authentication token required." });

    const payload = jwt.verify(token, JWT_SECRET);
    const userRecord = db.prepare("SELECT * FROM users WHERE id = ?").get(payload.userId);
    if (!userRecord) return res.status(401).json({ error: "Authenticated user not found." });
    if (payload.sessionId && !isActiveServerSession(payload.sessionId, userRecord.id)) {
      return res.status(401).json({ error: "Session has expired or been revoked." });
    }

    const role = normalizeRoleName(userRecord.role || payload.role);
    if (!["administrator", "system"].includes(role)) {
      return res.status(403).json({ error: "Administrator access required." });
    }

    req.authUser = {
      userId: userRecord.id,
      role,
      email: userRecord.email,
      sessionId: payload.sessionId,
      breakGlass: userRecord.break_glass_account === 1
    };
    next();
  } catch (error) {
    return res.status(401).json({ error: "Invalid or expired authentication token." });
  }
}

function requireBreakGlassAccess(req, res, next) {
  requireAdminAccess(req, res, () => {
    if (req.authUser.role === "system" && req.authUser.breakGlass) return next();
    return res.status(403).json({ error: "Break-glass emergency authority required." });
  });
}

function isActiveServerSession(sessionId, userId) {
  const session = db.prepare(`
    SELECT id
    FROM auth_sessions
    WHERE id = ?
      AND user_id = ?
      AND status = 'active'
      AND expires_at > CURRENT_TIMESTAMP
  `).get(sessionId, userId);
  return Boolean(session);
}

function normalizeRoleName(role) {
  const normalized = String(role || "").trim().toLowerCase();
  if (["system", "system_admin", "developer", "owner", "super_admin"].includes(normalized)) return "system";
  if (["administrator", "admin", "firm_admin"].includes(normalized)) return "administrator";
  return "staff";
}

function isProtectedSystemAccount(user) {
  return Boolean(user && user.protected_account === 1);
}

function applyProtectedSystemPayload(payload) {
  payload.role = "system_admin";
  payload.access_status = "active";
  payload.is_active = 1;
  payload.unrestricted_access = 1;
  payload.credential_storage_allowed = 0;
  payload.clearance_level = 999;
  payload.step_up_cadence = "every_login";
  payload.mfa_required = 1;
  return payload;
}

function enforceProtectedSystemAccount(user) {
  if (!isProtectedSystemAccount(user)) return false;
  if (user.emergency_suspended_at) return false;

  db.prepare(`
    UPDATE users
    SET role = 'system_admin',
        access_status = 'active',
        is_active = 1,
        unrestricted_access = 1,
        credential_storage_allowed = 0,
        clearance_level = 999,
        step_up_cadence = 'every_login',
        mfa_required = 1
    WHERE id = ?
  `).run(user.id);

  return true;
}

function repairProtectedSystemAccounts() {
  try {
    db.prepare("SELECT * FROM users").all().forEach((user) => {
      enforceProtectedSystemAccount(user);
    });
  } catch (error) {
    console.error("Protected System / Developer repair failed:", error.message);
  }
}

function hasProtectedSystemOverride(payload) {
  const protectedFields = new Set([
    "role",
    "access_status",
    "is_active",
    "unrestricted_access",
    "credential_storage_allowed",
    "clearance_level",
    "live_monitoring_access",
    "protected_account",
    "break_glass_account",
    "emergency_suspended_at",
    "emergency_suspension_reason",
    "full_name",
    "username",
    "email",
    "email_aliases",
    "password_hash",
    "passcode_hashes"
  ]);

  return Object.keys(payload).some((field) => protectedFields.has(field));
}

function requireChangeReason(req) {
  const reason = String(req.body?.reason || req.body?.changeReason || "").trim();
  return reason.length >= 8 ? reason : "";
}

function revokeUserSessions(userId, status) {
  db.prepare(`
    UPDATE auth_sessions
    SET status = ?,
        last_seen_at = CURRENT_TIMESTAMP,
        forced_logout_at = CURRENT_TIMESTAMP
    WHERE user_id = ? AND status = 'active'
  `).run(status || "revoked", userId);
}

function revokeTrustedDevices(userId) {
  db.prepare(`
    UPDATE auth_trusted_devices
    SET revoked_at = CURRENT_TIMESTAMP
    WHERE user_id = ? AND revoked_at IS NULL
  `).run(userId);
}

function getUserTableColumns() {
  return db.prepare("PRAGMA table_info(users)").all().map((column) => column.name);
}

function sanitizeUserPayload(payload) {
  const columns = new Set(getUserTableColumns());
  return Object.fromEntries(
    Object.entries(payload)
      .filter(([column, value]) => columns.has(column) && typeof value !== "undefined")
      .map(([column, value]) => [column, value === null ? null : value])
  );
}

function findUserByIdentity(identity) {
  const normalized = String(identity || "").trim().toLowerCase();
  const users = db.prepare("SELECT * FROM users").all();

  return users.find((user) => {
    const aliases = parseList(user.email_aliases).map((item) => item.toLowerCase());
    return (
      String(user.email || "").toLowerCase() === normalized ||
      String(user.username || "").toLowerCase() === normalized ||
      String(user.phone_number || "").toLowerCase() === normalized ||
      aliases.includes(normalized)
    );
  }) || null;
}

/**
 * LEOS_OWNER_BREAK_GLASS
 *
 * Development-only Owner Break-Glass authentication.
 *
 * - Disabled in production.
 * - Explicitly enabled by environment setting.
 * - Existing protected account only.
 * - Exact configured username only.
 * - Localhost/loopback only.
 * - Uses Node crypto.scryptSync and timingSafeEqual.
 * - Never records or returns the submitted secret.
 */
function verifyOwnerBreakGlassCredential(req, user, submittedSecret) {
  const rejected = {
    valid: false,
    factor: null
  };

  if (process.env.NODE_ENV === "production") {
    return rejected;
  }

  const enabled = String(
    process.env.LEOS_OWNER_BREAK_GLASS_ENABLED || ""
  )
    .trim()
    .toLowerCase();

  if (enabled !== "true") {
    return rejected;
  }

  if (!user || !isProtectedSystemAccount(user)) {
    return rejected;
  }

  if (!isOwnerBreakGlassLoopbackRequest(req)) {
    return rejected;
  }

  const configuredUsername = String(
    process.env.LEOS_OWNER_BREAK_GLASS_USERNAME || ""
  )
    .trim()
    .toLowerCase();

  const accountUsername = String(
    user.username || ""
  )
    .trim()
    .toLowerCase();

  if (
    !configuredUsername ||
    !accountUsername ||
    configuredUsername !== accountUsername
  ) {
    return rejected;
  }

  const submitted = String(submittedSecret || "");
  const verifier = String(
    process.env.LEOS_OWNER_BREAK_GLASS_SCRYPT || ""
  );

  const parts = verifier.split(":");

  if (!submitted || parts.length !== 2) {
    return rejected;
  }

  try {
    const salt = Buffer.from(parts[0], "hex");
    const expected = Buffer.from(parts[1], "hex");
    const actual = crypto.scryptSync(
      submitted,
      salt,
      expected.length
    );

    if (
      expected.length !== actual.length ||
      !crypto.timingSafeEqual(expected, actual)
    ) {
      writeSecurityEvent(
        user.id || accountUsername,
        "LEOS_OWNER_BREAK_GLASS_FAILED",
        req.ip,
        "Protected owner recovery credential rejected"
      );

      return rejected;
    }
  } catch (error) {
    return rejected;
  }

  return {
    valid: true,
    factor: "owner_break_glass"
  };
}

function isOwnerBreakGlassLoopbackRequest(req) {
  const values = [
    req?.ip,
    req?.socket?.remoteAddress,
    req?.connection?.remoteAddress,
    req?.headers?.host
  ]
    .filter(Boolean)
    .map((value) =>
      String(value)
        .trim()
        .toLowerCase()
    );

  return values.some((value) =>
    value === "127.0.0.1" ||
    value === "::1" ||
    value === "::ffff:127.0.0.1" ||
    value === "localhost" ||
    value.startsWith("127.0.0.1:") ||
    value.startsWith("localhost:")
  );
}

function isLocalProtectedDeveloperBuildSession(req, user, credentialCheck) {
  if (process.env.NODE_ENV === "production") return false;
  if (!user || user.protected_account !== 1 || user.break_glass_account !== 1) return false;
  if (normalizeRoleName(user.role) !== "system") return false;
  if (!isOwnerBreakGlassLoopbackRequest(req)) return false;
  return ["password", "admin_passcode", "owner_break_glass"].includes(credentialCheck?.factor);
}

async function verifyCredential(user, secret, requestedMethod = "password") {
  if (["otp", "qr", "qr_approval", "totp"].includes(requestedMethod) && user.qr_secret && user.authenticator_verified_at) {
    if (verifyTotpCode(user.qr_secret, secret)) {
      return { valid: true, factor: "authenticator_app" };
    }
  }

  if (await bcrypt.compare(secret, user.password_hash || "")) {
    return { valid: true, factor: "password" };
  }

  const passcodeHashes = parseList(user.passcode_hashes);
  for (const hash of passcodeHashes) {
    if (await bcrypt.compare(secret, hash)) {
      return { valid: true, factor: "admin_passcode" };
    }
  }

  return { valid: false, factor: null };
}

function normalizeAuthMethod(method) {
  const normalized = String(method || "password").trim().toLowerCase();
  if (["qr", "qr_approval", "authenticator"].includes(normalized)) return "qr_approval";
  if (["otp", "totp", "one_time_code"].includes(normalized)) return "otp";
  if (normalized === "passkey") return "passkey";
  return "password";
}

function generateBase32Secret(byteLength = 20) {
  return base32Encode(crypto.randomBytes(byteLength));
}

function verifyTotpCode(secret, code, options = {}) {
  const digits = options.digits || 6;
  const period = options.period || 30;
  const window = options.window || 1;
  const submitted = String(code || "").trim();
  if (!new RegExp(`^\\d{${digits}}$`).test(submitted)) return false;

  const counter = Math.floor(Date.now() / 1000 / period);
  for (let offset = -window; offset <= window; offset += 1) {
    if (totp(secret, counter + offset, digits) === submitted) return true;
  }
  return false;
}

function totp(secret, counter, digits = 6) {
  const key = base32Decode(secret);
  const buffer = Buffer.alloc(8);
  buffer.writeUInt32BE(Math.floor(counter / 0x100000000), 0);
  buffer.writeUInt32BE(counter & 0xffffffff, 4);

  const hmac = crypto.createHmac("sha1", key).update(buffer).digest();
  const offset = hmac[hmac.length - 1] & 0xf;
  const binary = ((hmac[offset] & 0x7f) << 24) |
    ((hmac[offset + 1] & 0xff) << 16) |
    ((hmac[offset + 2] & 0xff) << 8) |
    (hmac[offset + 3] & 0xff);

  return String(binary % (10 ** digits)).padStart(digits, "0");
}

function base32Encode(buffer) {
  const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
  let bits = "";
  for (const byte of buffer) bits += byte.toString(2).padStart(8, "0");

  let output = "";
  for (let index = 0; index < bits.length; index += 5) {
    const chunk = bits.slice(index, index + 5).padEnd(5, "0");
    output += alphabet[parseInt(chunk, 2)];
  }
  return output;
}

function base32Decode(value) {
  const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
  const cleaned = String(value || "").toUpperCase().replace(/=+$/g, "").replace(/[^A-Z2-7]/g, "");
  let bits = "";
  for (const char of cleaned) {
    const index = alphabet.indexOf(char);
    if (index >= 0) bits += index.toString(2).padStart(5, "0");
  }

  const bytes = [];
  for (let index = 0; index + 8 <= bits.length; index += 8) {
    bytes.push(parseInt(bits.slice(index, index + 8), 2));
  }
  return Buffer.from(bytes);
}

function hasSupplementalIdentityProfile(profile) {
  return Boolean(
    profile &&
    [
      profile.phoneNumber,
      profile.legalName,
      profile.initials,
      profile.nricLast4
    ].some((value) => String(value || "").trim())
  );
}

function parseList(value) {
  if (!value) return [];
  if (Array.isArray(value)) return value;

  try {
    const parsed = JSON.parse(value);
    return Array.isArray(parsed) ? parsed : [];
  } catch (error) {
    return String(value)
      .split(",")
      .map((item) => item.trim())
      .filter(Boolean);
  }
}

function writeAdaptiveAudit(event) {
  db.prepare(`
    INSERT INTO auth_audit_events (id, user_id, event_type, decision, risk_score, ip_address, user_agent, details_json)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `).run(
    cryptoId(),
    event.userId,
    event.eventType,
    event.decision,
    event.riskScore || 0,
    event.ipAddress || null,
    event.userAgent || null,
    JSON.stringify(event.details || {})
  );
}

function writeSecurityEvent(email, eventType, ipAddress, details) {
  try {
    db.prepare(`
      INSERT INTO security_events (email, event_type, ip_address, details)
      VALUES (?, ?, ?, ?)
    `).run(email || null, eventType, ipAddress || null, details || null);
  } catch (error) {
    console.error("Security event write failed:", error.message);
  }
}

function cryptoId() {
  return `${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 10)}`;
}

module.exports = router;


