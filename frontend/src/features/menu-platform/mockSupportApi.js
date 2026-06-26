const MAX_ATTACHMENT_SIZE_BYTES = 5 * 1024 * 1024;

const ALLOWED_ATTACHMENT_TYPES = [
  "image/png",
  "image/jpeg",
  "image/webp",
  "text/plain",
  "application/json",
];

export function validateSupportAttachment(file) {
  if (!file) return { ok: true };

  if (file.size > MAX_ATTACHMENT_SIZE_BYTES) {
    return {
      ok: false,
      message: `${file.name} is too large. Maximum size is 5MB.`,
    };
  }

  if (!ALLOWED_ATTACHMENT_TYPES.includes(file.type)) {
    return {
      ok: false,
      message: `${file.name} is not supported. Use PNG, JPG, WEBP, TXT, or JSON.`,
    };
  }

  return { ok: true };
}

export function redactSensitiveLogText(value) {
  return String(value || "")
    .replace(/Bearer\s+[A-Za-z0-9._-]+/gi, "Bearer [REDACTED]")
    .replace(/password\s*[:=]\s*\S+/gi, "password=[REDACTED]")
    .replace(/token\s*[:=]\s*\S+/gi, "token=[REDACTED]")
    .replace(/api[_-]?key\s*[:=]\s*\S+/gi, "apiKey=[REDACTED]")
    .replace(/\b\d{6}-\d{2}-\d{4}\b/g, "[REDACTED-ID]")
    .replace(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/gi, "[REDACTED-EMAIL]");
}

export async function submitSupportRequest(payload) {
  await new Promise((resolve) => setTimeout(resolve, 650));

  const ticketId = `SUP-${new Date().getFullYear()}-${Math.random()
    .toString(36)
    .slice(2, 8)
    .toUpperCase()}`;

  return {
    ok: true,
    ticketId,
    receivedAt: new Date().toISOString(),
    status: "received",
    summary: {
      issueType: payload.issueType,
      title: payload.title,
      attachmentCount: payload.attachments?.length || 0,
      includesLogs: Boolean(payload.logs),
    },
  };
}
