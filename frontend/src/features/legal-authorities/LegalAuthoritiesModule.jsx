import { useEffect, useMemo, useState } from "react";
import { legalAuthoritiesApi } from "./api/legalAuthoritiesApi";
import "./LegalAuthoritiesModule.css";

const Icon = ({ name }) => <span className="la-icon" aria-hidden="true">{{ source: "◉", type: "§", search: "⌕", refresh: "↻", shield: "◇", link: "↗", seed: "+" }[name] || "•"}</span>;
const normalizeRole = (user) => String(user?.role || user?.role_id || "").toLowerCase();
const canAdmin = (user) => ["system", "system_admin", "administrator", "admin", "legal_knowledge_admin", "source_manager"].includes(normalizeRole(user));

export default function LegalAuthoritiesModule({ user }) {
  const [tab, setTab] = useState("sources"); const [sources, setSources] = useState([]); const [types, setTypes] = useState([]); const [summary, setSummary] = useState(null);
  const [query, setQuery] = useState(""); const [status, setStatus] = useState("loading"); const [error, setError] = useState(""); const [busy, setBusy] = useState(false);
  const administrator = canAdmin(user);
  const load = async () => { setStatus("loading"); setError(""); try { const [summaryData, sourceData, typeData] = await Promise.all([legalAuthoritiesApi.summary(), legalAuthoritiesApi.sources(), legalAuthoritiesApi.authorityTypes()]); setSummary(summaryData); setSources(sourceData.sources || []); setTypes(typeData.authorityTypes || []); setStatus("ready"); } catch (err) { setError(err.message); setStatus(err.code === "LEGAL_SCHEMA_REQUIRED" ? "schema-required" : "error"); } };
  useEffect(() => {
    let active = true;
    Promise.all([legalAuthoritiesApi.summary(), legalAuthoritiesApi.sources(), legalAuthoritiesApi.authorityTypes()])
      .then(([summaryData, sourceData, typeData]) => { if (!active) return; setSummary(summaryData); setSources(sourceData.sources || []); setTypes(typeData.authorityTypes || []); setStatus("ready"); })
      .catch((err) => { if (!active) return; setError(err.message); setStatus(err.code === "LEGAL_SCHEMA_REQUIRED" ? "schema-required" : "error"); });
    return () => { active = false; };
  }, []);
  const visibleSources = useMemo(() => { const q = query.trim().toLowerCase(); return !q ? sources : sources.filter((item) => `${item.source_name} ${item.provider_name} ${item.source_category}`.toLowerCase().includes(q)); }, [sources, query]);
  const seed = async () => { setBusy(true); setError(""); try { await legalAuthoritiesApi.seedFoundation(); await load(); } catch (err) { setError(err.message); } finally { setBusy(false); } };
  const toggle = async (source) => { setBusy(true); try { const data = await legalAuthoritiesApi.updateSource(source.source_id, { enabled: source.enabled ? 0 : 1 }); setSources((items) => items.map((item) => item.source_id === source.source_id ? data.source : item)); } catch (err) { setError(err.message); } finally { setBusy(false); } };

  return <section className="la-module" aria-labelledby="la-heading">
    <header className="la-intro"><div><p className="eyebrow">Malaysia-first legal knowledge platform</p><h2 id="la-heading"><Icon name="shield" />Legal Authorities & Knowledge</h2><p>Structured authority metadata, governed sources, configurable classifications and licence-aware access. Official, licensed, internal and AI material remain separately labelled.</p></div><button type="button" onClick={load} disabled={status === "loading"}><Icon name="refresh" />Refresh registry</button></header>
    {summary && <div className="la-summary" aria-label="Registry summary"><article><strong>{summary.sources}</strong><span>Sources</span></article><article><strong>{summary.authorityTypes}</strong><span>Authority types</span></article><article><strong>{summary.authorities}</strong><span>Authorities</span></article><article><strong>{summary.pendingVerification}</strong><span>Pending verification</span></article></div>}
    {status === "schema-required" && <div className="la-message warning"><strong>Database foundation not installed.</strong><span>Migration 025 must be reviewed, backed up and applied in an approved environment. Opening this page never applies it automatically.</span></div>}
    {status === "error" && <div className="la-message error"><strong>Legal Authorities API unavailable.</strong><span>{error}</span></div>}
    {error && status === "ready" && <div className="la-message error">{error}</div>}
    <nav className="la-tabs" aria-label="Legal authority sections"><button className={tab === "sources" ? "active" : ""} onClick={() => setTab("sources")}><Icon name="source" />Source Registry</button><button className={tab === "types" ? "active" : ""} onClick={() => setTab("types")}><Icon name="type" />Authority Types</button></nav>
    {status === "ready" && tab === "sources" && <><div className="la-toolbar"><label><span><Icon name="search" />Search sources</span><input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Provider, category or source…" /></label>{administrator && summary?.sources === 0 && <button onClick={seed} disabled={busy}><Icon name="seed" />Seed reviewed foundation</button>}</div><div className="la-grid">{visibleSources.map((source) => <article className="la-card" key={source.source_id}><header><div><small>{source.source_category.replaceAll("_", " ")}</small><h3>{source.source_name}</h3></div><span className={`la-badge ${source.enabled ? "enabled" : "disabled"}`}>{source.enabled ? "Enabled" : "Disabled"}</span></header><p>{source.provider_name}</p><dl><div><dt>Authority</dt><dd>{source.authority_rank}</dd></div><div><dt>Access</dt><dd>{source.access_type}</dd></div><div><dt>Integration</dt><dd>{source.integration_mode}</dd></div><div><dt>Verification</dt><dd>{source.verification_status}</dd></div><div><dt>Full text</dt><dd>{source.full_text_storage_allowed ? "Permitted" : "Not permitted"}</dd></div></dl><div className="la-card-actions"><a href={source.base_url} target="_blank" rel="noreferrer"><Icon name="link" />Open source</a>{administrator && <button onClick={() => toggle(source)} disabled={busy}><Icon name="shield" />{source.enabled ? "Disable" : "Enable"}</button>}</div></article>)}</div></>}
    {status === "ready" && tab === "types" && <div className="la-type-groups">{Object.entries(Object.groupBy ? Object.groupBy(types, (item) => item.category_group) : types.reduce((groups, item) => ({ ...groups, [item.category_group]: [...(groups[item.category_group] || []), item] }), {})).map(([group, items]) => <section key={group}><h3><Icon name="type" />{group.replaceAll("_", " ")}</h3><div>{items.map((item) => <span key={item.authority_type}>{item.display_name}</span>)}</div></section>)}</div>}
    {status === "loading" && <div className="la-message">Loading governed legal-authority registry…</div>}
  </section>;
}
