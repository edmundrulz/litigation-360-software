import { useEffect, useState } from "react";
import "./SecurityAccessConsole.css";

const API_BASE = import.meta.env.VITE_API_BASE_URL || "http://localhost:5000/api";
const FAST_ACCESS_KEY = "l360_fast_access_profile";

function todayKey() {
  return new Date().toISOString().slice(0, 10);
}

function businessDayEndIso() {
  const end = new Date();
  end.setHours(18, 0, 0, 0);
  return end.toISOString();
}

function getFastAccessProfile() {
  try {
    const profile = JSON.parse(window.localStorage.getItem(FAST_ACCESS_KEY) || "null");
    if (!profile || profile.date !== todayKey()) return null;
    if (profile.until && new Date(profile.until).getTime() < Date.now()) return null;
    return profile;
  } catch {
    return null;
  }
}

function formatDuration(seconds) {
  const safeSeconds = Math.max(Number(seconds || 0), 0);
  const hours = Math.floor(safeSeconds / 3600);
  const minutes = Math.floor((safeSeconds % 3600) / 60);

  if (hours > 0) return `${hours}h ${minutes}m`;
  if (minutes > 0) return `${minutes}m`;
  return `${safeSeconds}s`;
}

export default function SecurityAccessConsole({ mode = "admin", onAuthenticated, lockedReason = "" }) {
  const isGateway = mode === "gateway";
  const fastAccessProfile = getFastAccessProfile();
  const [securityDisplay, setSecurityDisplay] = useState({
    phrase: "Clear Ledger",
    colour: "green"
  });
  const [form, setForm] = useState({
    accessRole: fastAccessProfile?.role || "",
    identity: fastAccessProfile?.identity || "",
    password: "",
    initials: "",
    nricLast4: "",
    method: "password"
  });
  const [result, setResult] = useState("Enter your credentials to continue.");
  const [challenge, setChallenge] = useState(null);
  const [challengeCode, setChallengeCode] = useState("");
  const [sessions, setSessions] = useState([]);
  const [showPassword, setShowPassword] = useState(false);
  const [showSupplemental, setShowSupplemental] = useState(false);

  const methodLabels = {
    password: "Password or PIN",
    passkey: "Passkey confirmation",
    qr: "Authenticator 6-digit code",
    otp: "Authenticator 6-digit code"
  };

  const methodOptions = [
    ["password", "Password"],
    ["passkey", "Passkey"],
    ["qr", "QR / Authenticator"],
    ["otp", "One-time code"]
  ];

  const roleOptions = [
    ["staff", "Staff"],
    ["administrator", "Administrator"],
    ["system", "System Administrator / Developer"]
  ];

  const lockHeading = String(lockedReason || "").toLowerCase().includes("logout") ||
    String(lockedReason || "").toLowerCase().includes("signed out")
    ? "Signed out securely"
    : "Session locked";

  useEffect(() => {
    fetch(`${API_BASE}/adaptive-auth/security-display`)
      .then((response) => response.json())
      .then(setSecurityDisplay)
      .catch(() => {});

    fetch(`${API_BASE}/adaptive-auth/sessions`)
      .then((response) => response.json())
      .then((data) => setSessions(data.sessions || []))
      .catch(() => setSessions([]));
  }, []);

  async function evaluateLogin(event) {
    event.preventDefault();
    setResult("Checking access policy...");
    setChallenge(null);

    try {
      const response = await fetch(`${API_BASE}/adaptive-auth/start`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          identity: form.identity,
          password: form.password,
          method: form.method,
          requestedRole: form.accessRole,
          requestedModule: "legal_records",
          identityProfile: {
            username: form.identity,
            email: form.identity,
            initials: form.initials,
            nricLast4: form.nricLast4
          }
        })
      });

      const data = await response.json();
      if (!response.ok) {
        setResult(data.error || "Login could not be approved.");
        return;
      }

      if (data.challengeId) {
        setChallenge(data);
        setResult(`Extra verification required: ${data.requiredFactors.join(" + ")}`);
        return;
      }

      setResult(`Login approved at assurance level ${data.assuranceLevel}.`);
      completeAuthentication(data);
    } catch (error) {
      setResult("Backend is not reachable. Start the backend server and try again.");
    }
  }

  async function verifyChallenge() {
    if (!challenge) return;
    setResult("Verifying challenge...");

    try {
      const response = await fetch(`${API_BASE}/adaptive-auth/challenge`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          challengeId: challenge.challengeId,
          code: challengeCode
        })
      });

      const data = await response.json();
      if (!response.ok) {
        setResult(data.error || "Challenge failed.");
        return;
      }

      setChallenge(null);
      setChallengeCode("");
      setResult(`Challenge complete. Session trusted at level ${data.assuranceLevel}.`);
      completeAuthentication(data);
    } catch (error) {
      setResult("Challenge service is not reachable.");
    }
  }

  function updateForm(key, value) {
    setForm((current) => ({ ...current, [key]: value }));
  }

  function completeAuthentication(data) {
    if (data.token) {
      const user = data.user || {};
      const sessionStartedAt = new Date().toISOString();
      window.sessionStorage.setItem("l360_adaptive_auth_token", data.token);
      window.sessionStorage.setItem("l360_adaptive_auth_user", JSON.stringify(user));
      window.sessionStorage.setItem("l360_session_started_at", sessionStartedAt);
      window.localStorage.setItem(FAST_ACCESS_KEY, JSON.stringify({
        date: todayKey(),
        until: businessDayEndIso(),
        identity: user.username || user.email || form.identity,
        displayName: user.full_name || user.username || user.email || "Authorized user",
        role: user.role || form.accessRole,
        userId: user.id || null
      }));
    }

    if (typeof onAuthenticated === "function") {
      onAuthenticated(data);
    }
  }

  return (
    <main className={`security-access-shell ${isGateway ? "security-gateway-shell" : "security-admin-shell"}`}>
      <section className="security-login-panel" aria-labelledby="securityLoginTitle">
        <div className="security-brand-row">
          <div className="security-brand-mark">L360</div>
          <div>
            <strong>LEOS 360</strong>
            <span>{isGateway ? "Secure system gateway" : "Adaptive authentication"}</span>
          </div>
        </div>

        <form className="security-login-box" onSubmit={evaluateLogin}>
          <p className="security-eyebrow">Secure sign in</p>
          <h1 id="securityLoginTitle">{isGateway ? "Sign in to Litigation 360" : "Access is verified by risk, role and device."}</h1>

          {lockedReason && (
            <div className="security-lock-note" role="status">
              <strong>{lockHeading}</strong>
              <span>{lockedReason}</span>
            </div>
          )}

          {isGateway && fastAccessProfile && (
            <div className="security-fast-note">
              <strong>Fast access available today</strong>
              <span>Enter your password, PIN or passcode to unlock again without repeating the full first-login check.</span>
            </div>
          )}

          <div className="security-display" aria-label="Current access policy">
            <span>Access phrase</span>
            <strong>{securityDisplay.phrase}</strong>
            <em>{securityDisplay.colour} verification active</em>
          </div>

          <label>
            <span>Access role requested</span>
            <select
              value={form.accessRole}
              onChange={(event) => updateForm("accessRole", event.target.value)}
              required
            >
              <option value="">Select your authorised role</option>
              {roleOptions.map(([role, label]) => (
                <option key={role} value={role}>{label}</option>
              ))}
            </select>
          </label>

          <label>
            <span>Username, email or phone</span>
            <input
              value={form.identity}
              onChange={(event) => updateForm("identity", event.target.value)}
              autoComplete="username"
              placeholder="name@firm.com"
              required
            />
          </label>

          <label>
            <span>{methodLabels[form.method]}</span>
            <div className="security-password-row">
              <input
                value={form.password}
                onChange={(event) => updateForm("password", event.target.value)}
                type={showPassword ? "text" : "password"}
                autoComplete={form.accessRole === "system" ? "new-password" : "current-password"}
                placeholder="Enter secure credential"
                required
              />
              <button type="button" onClick={() => setShowPassword((current) => !current)}>
                {showPassword ? "Hide" : "Show"}
              </button>
            </div>
          </label>

          <div className="security-help-row">
            <button type="button">Forgot password or PIN?</button>
            <button type="button">Contact support</button>
          </div>

          <div className="security-method-row" aria-label="Authentication method">
            {methodOptions.map(([method, label]) => (
              <button
                key={method}
                type="button"
                className={form.method === method ? "active" : ""}
                aria-pressed={form.method === method}
                onClick={() => updateForm("method", method)}
              >
                {label}
              </button>
            ))}
          </div>

          <button className="security-secondary-toggle" type="button" onClick={() => setShowSupplemental((current) => !current)}>
            {showSupplemental ? "Hide additional verification" : "Add initials or NRIC check"}
          </button>

          {showSupplemental && (
            <div className="security-identity-grid">
              <label>
                <span>Initials</span>
                <input value={form.initials} onChange={(event) => updateForm("initials", event.target.value)} maxLength={8} autoComplete="off" />
              </label>
              <label>
                <span>NRIC last 4</span>
                <input value={form.nricLast4} onChange={(event) => updateForm("nricLast4", event.target.value)} maxLength={4} inputMode="numeric" autoComplete="off" />
              </label>
            </div>
          )}

          <button className="security-primary" type="submit">Sign in securely</button>
          <p className="security-result" role="status">{result}</p>
        </form>

        {challenge && (
          <div className="security-challenge-box">
            <strong>Additional verification</strong>
            <span>Enter the 6-digit code from Google Authenticator or Microsoft Authenticator.</span>
            <input
              value={challengeCode}
              onChange={(event) => setChallengeCode(event.target.value)}
              inputMode="numeric"
              placeholder="000000"
            />
            <button type="button" onClick={verifyChallenge}>Verify challenge</button>
          </div>
        )}
      </section>

      <section className="security-monitor-panel" aria-labelledby="securityMonitorTitle">
        <div>
          <p className="security-eyebrow">{isGateway ? "Access protection" : "Security command"}</p>
          <h2 id="securityMonitorTitle">{isGateway ? "Protected entrance" : "Live access monitoring"}</h2>
        </div>

        {isGateway ? (
          <div className="security-gateway-copy">
            <p>
              Access is opened only after the account, role, device trust and security policy all match the stored user record.
            </p>
            <ul>
              <li>Password, PIN, OTP, QR approval and passkey-ready sign-in.</li>
              <li>Role-gated entry for staff, administrators and system access.</li>
              <li>Revoked, expired or suspended access is blocked before entry.</li>
            </ul>
          </div>
        ) : (
          <div className="security-metrics">
            <article>
              <span>Active sessions</span>
              <strong>{sessions.length}</strong>
            </article>
            <article>
              <span>Step-up due</span>
              <strong>Policy</strong>
            </article>
            <article>
              <span>Locked</span>
              <strong>Audit</strong>
            </article>
            <article>
              <span>High risk</span>
              <strong>Score</strong>
            </article>
          </div>
        )}

        {!isGateway && <div className="security-session-table" role="table" aria-label="Active sessions">
          <div className="security-table-row security-table-head" role="row">
            <span>User</span>
            <span>Level</span>
            <span>Status</span>
            <span>Duration</span>
            <span>Last seen</span>
          </div>
          {sessions.length ? (
            sessions.map((session) => (
              <div className="security-table-row" role="row" key={session.id}>
                <span>{session.email}</span>
                <span>{session.assurance_level}</span>
                <span className="security-pill strong">{session.status}</span>
                <span>{formatDuration(session.duration_seconds)}</span>
                <span>{session.last_seen_at}</span>
              </div>
            ))
          ) : (
            <div className="security-empty-state">No adaptive sessions recorded yet.</div>
          )}
        </div>}

        <div className="security-policy-list">
          <div>
            <strong>Additional verification</strong>
            <span>Required for sensitive records and elevated roles.</span>
          </div>
          <div>
            <strong>Trusted device review</strong>
            <span>Known devices can use faster access after first login.</span>
          </div>
          <div>
            <strong>Access suspension</strong>
            <span>Revoked, expired or suspended users are stopped.</span>
          </div>
        </div>
      </section>
    </main>
  );
}

