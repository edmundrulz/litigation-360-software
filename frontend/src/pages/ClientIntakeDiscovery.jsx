import ClientIntakeDiscoveryPrototype from "../components/ClientIntakeDiscoveryPrototype";

export default function ClientIntakeDiscovery() {
  return (
    <main className="client-intake-page" aria-labelledby="client-intake-title">
      <section className="client-intake-hero">
        <div>
          <p className="client-intake-eyebrow">Phase 14A Prototype</p>
          <h1 id="client-intake-title">Client Intake Discovery</h1>
          <p>
            Frontend-only intake discovery shell using mock/local state only.
            No backend save, no real client creation, no matter creation, and no file upload.
          </p>
        </div>

        <div className="client-intake-status" aria-label="Prototype status">
          <strong>Prototype mode</strong>
          <span>No backend save</span>
          <span>No real client or matter creation</span>
        </div>
      </section>

      <ClientIntakeDiscoveryPrototype />
    </main>
  );
}
