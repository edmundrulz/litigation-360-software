export async function submitSupportRequest(payload) {
  await new Promise((resolve) => setTimeout(resolve, 450));

  return {
    ok: true,
    status: "Mock Submitted",
    referenceId: payload.referenceId,
    received: {
      category: payload.category,
      priority: payload.priority,
      subject: payload.subject,
      attachmentCount: payload.attachments?.length || 0,
      includeDiagnostics: Boolean(payload.includeDiagnostics),
    },
  };
}
