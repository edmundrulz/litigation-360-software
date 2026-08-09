import { useMemo, useRef, useState } from "react";
import "./LegalReferenceWorkspace.css";
import LegalReferenceIcon from "./LegalReferenceIcon";
import {
  glossarySource,
  importedGlossaryTerms,
} from "./generated/legalGlossary.generated";
import {
  registryMetadata,
  registryRecords,
} from "./malaysianAuthorityRegistry";

const starterTerms = [
  {
    term: "Affidavit",
    definition:
      "A written statement of facts affirmed or sworn before an authorised person and intended for use as evidence.",
    domain: "Evidence",
    jurisdiction: "Common law",
    related: ["Deponent", "Statutory declaration"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Arbitration",
    definition:
      "A private dispute-resolution process in which one or more arbitrators determine a dispute under an arbitration agreement.",
    domain: "Dispute resolution",
    jurisdiction: "General",
    related: ["Award", "Arbitration agreement"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Burden of proof",
    definition:
      "The obligation placed on a party to establish a fact or issue to the applicable standard of proof.",
    domain: "Evidence",
    jurisdiction: "General",
    related: ["Balance of probabilities", "Beyond reasonable doubt"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Cause of action",
    definition:
      "The material facts recognised by law as giving a person a right to seek a judicial remedy.",
    domain: "Civil procedure",
    jurisdiction: "Common law",
    related: ["Claim", "Limitation period"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Cause Papers",
    definition:
      "Court documents filed, issued or used in a proceeding; the precise scope of the expression depends on local procedural practice.",
    domain: "Civil procedure",
    jurisdiction: "Common law",
    related: ["Pleading", "Court filing"],
    source: "Restored original interface record",
    status: "review-required",
  },
  {
    term: "Client Due Diligence",
    definition:
      "Identity, authority, beneficial-ownership and risk checks undertaken before or during a professional engagement, subject to applicable law and policy.",
    domain: "Legal practice",
    jurisdiction: "Jurisdiction-specific",
    related: ["Know your client", "Conflict check"],
    source: "Restored original interface record",
    status: "review-required",
  },
  {
    term: "Consideration",
    definition:
      "Value supplied or promised in exchange for a contractual promise; requirements differ between legal systems.",
    domain: "Contract",
    jurisdiction: "Common law",
    related: ["Contract", "Promissory estoppel"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Estoppel",
    definition:
      "A doctrine that may prevent a person from denying a representation or position when the legal requirements are satisfied.",
    domain: "Equity",
    jurisdiction: "Common law",
    related: ["Promissory estoppel", "Representation"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Habeas corpus",
    pronunciation: "HAY-bee-us KOR-pus",
    definition:
      "A judicial remedy used to test the legality of a person's detention.",
    domain: "Constitutional",
    jurisdiction: "Common law",
    history:
      "Latin: ‘that you have the body’. Its scope depends on the governing jurisdiction.",
    related: ["Detention", "Judicial review"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Injunction",
    definition:
      "A court order requiring a person to do, or refrain from doing, a specified act.",
    domain: "Remedies",
    jurisdiction: "General",
    related: ["Interlocutory injunction", "Specific performance"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Judicial review",
    definition:
      "Court supervision of the legality of public decision-making, subject to the governing constitutional and statutory framework.",
    domain: "Administrative",
    jurisdiction: "General",
    related: ["Ultra vires", "Natural justice"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Limitation period",
    definition:
      "A period prescribed by law within which a proceeding or claim must ordinarily be commenced.",
    domain: "Civil procedure",
    jurisdiction: "Jurisdiction-specific",
    related: ["Accrual", "Cause of action"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Mens rea",
    pronunciation: "MENZ RAY-uh",
    definition:
      "The mental element required for an offence, where the applicable criminal law requires one.",
    domain: "Criminal",
    jurisdiction: "Common law",
    history:
      "Latin: ‘guilty mind’. The required mental state depends on the offence.",
    related: ["Actus reus", "Strict liability"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Natural justice",
    definition:
      "Procedural fairness principles commonly including an impartial decision-maker and a fair opportunity to be heard.",
    domain: "Administrative",
    jurisdiction: "Common law",
    related: ["Bias", "Right to be heard"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Precedent",
    definition:
      "An earlier judicial decision used as authority when deciding a later case; its weight depends on court hierarchy and legal system.",
    domain: "Legal method",
    jurisdiction: "Common law",
    related: ["Ratio decidendi", "Stare decisis"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Ratio decidendi",
    pronunciation: "RAY-shee-oh dess-ih-DEN-dye",
    definition:
      "The legal principle necessary to a court's decision and capable of operating as precedent.",
    domain: "Legal method",
    jurisdiction: "Common law",
    related: ["Obiter dictum", "Precedent"],
    source: "Curated starter record",
    status: "review-required",
  },
  {
    term: "Ultra vires",
    pronunciation: "UL-truh VY-reez",
    definition:
      "Beyond the legal power or authority conferred on a person or public body.",
    domain: "Administrative",
    jurisdiction: "General",
    related: ["Judicial review", "Jurisdiction"],
    source: "Curated starter record",
    status: "review-required",
  },
];

const authorityRecords = [
  {
    type: "Act",
    title: "Federal Constitution",
    jurisdiction: "Malaysia",
    citation: "Federal Constitution (Malaysia)",
    status: "Verify current consolidation",
    summary: "Malaysia's foundational constitutional instrument.",
    sourceUrl: "https://lom.agc.gov.my/",
    source: "Laws of Malaysia (AGC)",
    treatment:
      "Authoritative text must be retrieved from the official source before reliance.",
  },
  {
    type: "Act",
    title: "Contracts Act 1950",
    jurisdiction: "Malaysia",
    citation: "Act 136",
    status: "Verify current consolidation",
    summary:
      "Principal Malaysian legislation governing specified aspects of contracts.",
    sourceUrl: "https://lom.agc.gov.my/",
    source: "Laws of Malaysia (AGC)",
    treatment:
      "Section text and amendment history are intentionally not reproduced until verified.",
  },
  {
    type: "Act",
    title: "Evidence Act 1950",
    jurisdiction: "Malaysia",
    citation: "Act 56",
    status: "Verify current consolidation",
    summary:
      "Malaysian statutory framework governing evidence in covered proceedings.",
    sourceUrl: "https://lom.agc.gov.my/",
    source: "Laws of Malaysia (AGC)",
    treatment: "Check official reprint, commencement and amendments.",
  },
  {
    type: "Act",
    title: "Limitation Act 1953",
    jurisdiction: "Malaysia",
    citation: "Act 254",
    status: "Verify application",
    summary:
      "Addresses limitation periods for covered causes of action, subject to scope and exclusions.",
    sourceUrl: "https://lom.agc.gov.my/",
    source: "Laws of Malaysia (AGC)",
    treatment: "Confirm territorial and subject-matter application before use.",
  },
  {
    type: "Legislation",
    title: "Singapore legislation collection",
    jurisdiction: "Singapore",
    citation: "Singapore Statutes Online",
    status: "Official source link",
    summary:
      "Official consolidated legislation and subsidiary legislation search.",
    sourceUrl: "https://sso.agc.gov.sg/",
    source: "Singapore Statutes Online",
    treatment:
      "Select the required Act and historical version at the official source.",
  },
  {
    type: "Precedent",
    title: "Judicial decisions repository",
    jurisdiction: "Singapore",
    citation: "Singapore Courts Judgments",
    status: "Official source link",
    summary:
      "Official judgments and court materials for case-specific research.",
    sourceUrl: "https://www.judiciary.gov.sg/judgments",
    source: "Singapore Judiciary",
    treatment:
      "Case facts, holding and subsequent treatment require editorial verification.",
  },
];

const curatedByTerm = new Map(
  starterTerms.map((entry) => [entry.term.toLocaleLowerCase("en"), entry]),
);
const dictionaryTerms = importedGlossaryTerms.map((imported) => {
  const curated = curatedByTerm.get(imported.term.toLocaleLowerCase("en"));
  if (!curated)
    return {
      ...imported,
      domain: "General legal terminology",
      jurisdiction: "Unclassified / imported",
      related: [],
      source: glossarySource.fileName,
      status: "imported-unverified",
    };
  return {
    ...imported,
    ...curated,
    importedDefinition: imported.definition,
    sourceLine: imported.sourceLine,
    source: `${glossarySource.fileName} + curated enhancement`,
    status: "imported-and-enhanced",
  };
});
starterTerms.forEach((curated) => {
  if (
    !dictionaryTerms.some(
      (entry) =>
        entry.term.toLocaleLowerCase("en") ===
        curated.term.toLocaleLowerCase("en"),
    )
  )
    dictionaryTerms.push(curated);
});
dictionaryTerms.sort((a, b) =>
  a.term.localeCompare(b.term, "en", { sensitivity: "base" }),
);

const letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
const normalise = (value) =>
  value
    .toLowerCase()
    .normalize("NFKD")
    .replace(/[^a-z0-9 ]/g, "");
function distance(a, b) {
  const x = normalise(a);
  const y = normalise(b);
  const row = Array.from({ length: y.length + 1 }, (_, i) => i);
  for (let i = 1; i <= x.length; i += 1) {
    let prev = row[0];
    row[0] = i;
    for (let j = 1; j <= y.length; j += 1) {
      const old = row[j];
      row[j] = Math.min(
        row[j] + 1,
        row[j - 1] + 1,
        prev + (x[i - 1] === y[j - 1] ? 0 : 1),
      );
      prev = old;
    }
  }
  return row[y.length];
}

function download(name, content, type) {
  const url = URL.createObjectURL(new Blob([content], { type }));
  const link = document.createElement("a");
  link.href = url;
  link.download = name;
  link.click();
  URL.revokeObjectURL(url);
}
const escapeHtml = (value) =>
  String(value ?? "").replace(
    /[&<>"']/g,
    (character) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[
        character
      ],
  );

export default function LegalReferenceWorkspace() {
  const [module, setModule] = useState("dictionary");
  const [query, setQuery] = useState("");
  const [letter, setLetter] = useState("ALL");
  const [domain, setDomain] = useState("All domains");
  const [jurisdiction, setJurisdiction] = useState("All jurisdictions");
  const [sort, setSort] = useState("az");
  const [page, setPage] = useState(1);
  const [savedOnly, setSavedOnly] = useState(false);
  const pageSize = 40;
  const [bookmarks, setBookmarks] = useState(() =>
    JSON.parse(localStorage.getItem("l360-legal-bookmarks") || "[]"),
  );
  const [notes, setNotes] = useState(() =>
    JSON.parse(localStorage.getItem("l360-legal-notes") || "{}"),
  );
  const [message, setMessage] = useState("");
  const contentRef = useRef(null);
  const persistBookmarks = (next) => {
    setBookmarks(next);
    localStorage.setItem("l360-legal-bookmarks", JSON.stringify(next));
  };
  const persistNote = (id, value) => {
    const next = { ...notes, [id]: value };
    setNotes(next);
    localStorage.setItem("l360-legal-notes", JSON.stringify(next));
  };
  const announce = (text) => {
    setMessage(text);
    window.setTimeout(() => setMessage(""), 1800);
  };
  const resetPage = () => setPage(1);
  const moduleLabel =
    module === "dictionary"
      ? "Legal Dictionary A–Z"
      : module === "legislation"
        ? "Acts, Sections & Precedents"
        : "Malaysian Legal Authorities";
  const jump = (next) => {
    setModule(next);
    setPage(1);
    setJurisdiction("All jurisdictions");
    window.setTimeout(() => contentRef.current?.focus(), 0);
    announce(
      `Opened ${next === "dictionary" ? "Legal Dictionary" : next === "legislation" ? "Acts, Sections & Precedents" : "Malaysian Legal Authorities"}.`,
    );
  };
  const terms = useMemo(
    () =>
      dictionaryTerms
        .filter((item) => {
          const q = normalise(query);
          const matchesQuery =
            !q ||
            normalise(
              `${item.term} ${item.definition} ${(item.related || []).join(" ")}`,
            ).includes(q) ||
            distance(item.term, q) <= Math.max(1, Math.floor(q.length / 4));
          return (
            matchesQuery &&
            (letter === "ALL" || item.term.startsWith(letter)) &&
            (domain === "All domains" || item.domain === domain) &&
            (jurisdiction === "All jurisdictions" ||
              item.jurisdiction === jurisdiction)
          );
        })
        .sort((a, b) =>
          sort === "za"
            ? b.term.localeCompare(a.term)
            : a.term.localeCompare(b.term),
        ),
    [query, letter, domain, jurisdiction, sort],
  );
  const authorities = useMemo(
    () =>
      authorityRecords
        .filter(
          (item) =>
            !query ||
            normalise(
              `${item.title} ${item.citation} ${item.summary}`,
            ).includes(normalise(query)),
        )
        .filter(
          (item) =>
            jurisdiction === "All jurisdictions" ||
            item.jurisdiction === jurisdiction,
        ),
    [query, jurisdiction],
  );
  const registry = useMemo(
    () =>
      registryRecords
        .filter(
          (item) =>
            !query ||
            normalise(
              `${item.title} ${item.category} ${item.summary} ${item.citation}`,
            ).includes(normalise(query)),
        )
        .filter(
          (item) =>
            jurisdiction === "All jurisdictions" ||
            item.jurisdiction === jurisdiction,
        )
        .sort((a, b) =>
          sort === "za"
            ? b.title.localeCompare(a.title)
            : a.title.localeCompare(b.title),
        ),
    [query, jurisdiction, sort],
  );
  const exportResults = (word = false) => {
    const records =
      module === "dictionary"
        ? terms
        : module === "legislation"
          ? authorities
          : registry;
    const body = records
      .map(
        (r) =>
          `<h2>${escapeHtml(r.term || r.title)}</h2><p>${escapeHtml(r.definition || r.summary)}</p><p><b>Jurisdiction:</b> ${escapeHtml(r.jurisdiction)}</p><p><b>Status:</b> ${escapeHtml(r.status)}</p>`,
      )
      .join("");
    if (word)
      download(
        "LEOS-legal-reference.doc",
        `<html><meta charset="utf-8"><body><h1>LEOS Legal Reference Export</h1>${body}</body></html>`,
        "application/msword",
      );
    else window.print();
    announce(
      word
        ? "Word-compatible export created."
        : "Print dialog opened; choose Save as PDF.",
    );
  };
  const moduleRecords =
    module === "dictionary"
      ? terms
      : module === "legislation"
        ? authorities
        : registry;
  const activeRecords = savedOnly
    ? moduleRecords.filter((item) =>
        bookmarks.includes(item.term || item.title),
      )
    : moduleRecords;
  const pageCount = Math.max(1, Math.ceil(activeRecords.length / pageSize));
  const visibleRecords = activeRecords.slice(
    (page - 1) * pageSize,
    page * pageSize,
  );
  const copyResults = async () => {
    try {
      await navigator.clipboard.writeText(
        activeRecords
          .map(
            (item) =>
              `${item.term || item.title}: ${item.definition || item.summary}`,
          )
          .join("\n\n"),
      );
      announce("Filtered result set copied.");
    } catch {
      announce("Copy was blocked by the browser.");
    }
  };
  const shareWorkspace = async () => {
    try {
      if (navigator.share)
        await navigator.share({
          title: "LEOS Legal Reference Workspace",
          text: `${activeRecords.length} legal-reference records`,
          url: window.location.href,
        });
      else {
        await navigator.clipboard.writeText(window.location.href);
        announce("Workspace link copied.");
      }
    } catch {
      announce("Sharing was cancelled or blocked.");
    }
  };

  return (
    <div className="legal-reference-workspace">
      <div className="legal-reference-breadcrumb" aria-label="Breadcrumb">
        <span>Legal Tools</span>
        <span aria-hidden="true">›</span>
        <strong>{moduleLabel}</strong>
      </div>
      <nav
        className="legal-reference-shortcuts"
        aria-label="Legal reference modules"
      >
        {[
          {
            id: "dictionary",
            label: "Legal Dictionary A–Z",
            icon: "dictionary",
          },
          {
            id: "legislation",
            label: "Acts, Sections & Precedents",
            icon: "legislation",
          },
          {
            id: "registry",
            label: "Malaysian Legal Authorities",
            icon: "registry",
          },
        ].map((item) => (
          <button
            key={item.id}
            type="button"
            className={module === item.id ? "active" : ""}
            aria-current={module === item.id ? "page" : undefined}
            title={`Open ${item.label}`}
            onClick={() => jump(item.id)}
          >
            <LegalReferenceIcon name={item.icon} size={21} />
            <span>{item.label}</span>
          </button>
        ))}
      </nav>
      <div className="legal-reference-toolbar" role="search">
        <label>
          <span className="control-label">
            <LegalReferenceIcon name="search" /> Search legal references
          </span>
          <input
            value={query}
            onChange={(e) => {
              setQuery(e.target.value);
              resetPage();
            }}
            placeholder="Term, citation, topic or related concept…"
            autoComplete="off"
          />
        </label>
        <label>
          <span className="control-label">
            <LegalReferenceIcon name="filter" /> Legal domain
          </span>
          <select
            value={domain}
            disabled={module !== "dictionary"}
            onChange={(e) => {
              setDomain(e.target.value);
              resetPage();
            }}
          >
            <option>All domains</option>
            {[...new Set(dictionaryTerms.map((t) => t.domain))]
              .sort()
              .map((v) => (
                <option key={v}>{v}</option>
              ))}
          </select>
        </label>
        <label>
          <span className="control-label">
            <LegalReferenceIcon name="filter" /> Jurisdiction / system
          </span>
          <select
            value={jurisdiction}
            onChange={(e) => {
              setJurisdiction(e.target.value);
              resetPage();
            }}
          >
            <option>All jurisdictions</option>
            {[
              ...new Set(
                [...dictionaryTerms, ...authorityRecords].map(
                  (t) => t.jurisdiction,
                ),
              ),
            ]
              .sort()
              .map((v) => (
                <option key={v}>{v}</option>
              ))}
          </select>
        </label>
        <label>
          <span className="control-label">
            <LegalReferenceIcon name="all" /> Sort results
          </span>
          <select
            value={sort}
            onChange={(e) => {
              setSort(e.target.value);
              resetPage();
            }}
          >
            <option value="az">Title A–Z</option>
            <option value="za">Title Z–A</option>
          </select>
        </label>
      </div>
      {module === "dictionary" && (
        <nav className="legal-reference-az" aria-label="Dictionary alphabet">
          <button
            className={letter === "ALL" ? "active" : ""}
            onClick={() => {
              setLetter("ALL");
              resetPage();
            }}
          >
            <LegalReferenceIcon name="all" size={14} />
            All
          </button>
          {letters.map((l) => (
            <button
              key={l}
              disabled={!dictionaryTerms.some((t) => t.term.startsWith(l))}
              className={letter === l ? "active" : ""}
              aria-label={`Show terms beginning with ${l}`}
              aria-pressed={letter === l}
              onClick={() => {
                setLetter(l);
                resetPage();
              }}
            >
              <LegalReferenceIcon name="dictionary" size={12} />
              {l}
            </button>
          ))}
        </nav>
      )}
      <div className="legal-reference-actions">
        <span>
          {activeRecords.length} records · page {page} of {pageCount}
        </span>
        <button
          className={savedOnly ? "active" : ""}
          aria-pressed={savedOnly}
          onClick={() => {
            setSavedOnly((value) => !value);
            resetPage();
          }}
        >
          <LegalReferenceIcon name="collection" />
          {savedOnly ? "Show all records" : "Show saved"}
        </button>
        <button
          onClick={() => {
            setQuery("");
            setLetter("ALL");
            setDomain("All domains");
            setJurisdiction("All jurisdictions");
            setSort("az");
            setSavedOnly(false);
            resetPage();
            announce("Workspace filters reset.");
          }}
        >
          <LegalReferenceIcon name="reset" />
          Reset
        </button>
        <button onClick={copyResults}>
          <LegalReferenceIcon name="copy" />
          Copy results
        </button>
        <button onClick={shareWorkspace}>
          <LegalReferenceIcon name="share" />
          Share
        </button>
        <button onClick={() => exportResults(false)}>
          <LegalReferenceIcon name="print" />
          Export PDF
        </button>
        <button onClick={() => exportResults(true)}>
          <LegalReferenceIcon name="export" />
          Export Word
        </button>
      </div>
      <div className="legal-reference-notice">
        <strong>Research safeguard:</strong>{" "}
        {module === "registry"
          ? `${registryMetadata.title} contains source-directory and classification metadata from ${registryMetadata.sourcePackage}. It does not assert that linked material is current law. Check status, effective dates, licence terms and the controlling official text before reliance.`
          : `All ${glossarySource.count.toLocaleString()} original INI entries are included (SHA-256 ${glossarySource.sha256.slice(0, 12)}…). They have no citations, dates or jurisdiction metadata and remain “Imported unverified material”. Enhanced records retain the original definition separately. Verify against official sources before legal reliance.`}
      </div>
      <section
        className="legal-reference-results"
        ref={contentRef}
        tabIndex="-1"
        aria-label="Legal reference results"
      >
        {visibleRecords.map((item) => {
          const id = item.term || item.title;
          const saved = bookmarks.includes(id);
          return (
            <article className="legal-reference-entry" key={id}>
              <header>
                <div>
                  <span className="legal-reference-kind">
                    {item.type || item.domain}
                  </span>
                  <h3>
                    <LegalReferenceIcon
                      name={
                        module === "dictionary"
                          ? "dictionary"
                          : module === "registry"
                            ? "registry"
                            : "legislation"
                      }
                    />
                    {id}
                  </h3>
                </div>
                <button
                  className={saved ? "saved" : ""}
                  aria-pressed={saved}
                  title={saved ? "Remove bookmark" : "Bookmark this record"}
                  onClick={() => {
                    const next = saved
                      ? bookmarks.filter((v) => v !== id)
                      : [...bookmarks, id];
                    persistBookmarks(next);
                    announce(saved ? "Bookmark removed." : "Bookmark saved.");
                  }}
                >
                  <LegalReferenceIcon name={saved ? "saved" : "bookmark"} />
                  {saved ? "Saved" : "Bookmark"}
                </button>
              </header>
              <p>{item.definition || item.summary}</p>
              {item.pronunciation && (
                <p>
                  <strong>Pronunciation:</strong> {item.pronunciation}
                </p>
              )}
              {item.history && (
                <p>
                  <strong>History / etymology:</strong> {item.history}
                </p>
              )}
              {item.importedDefinition &&
                item.importedDefinition !== item.definition && (
                  <details>
                    <summary>Original supplied definition</summary>
                    <p>{item.importedDefinition}</p>
                  </details>
                )}
              <dl>
                <div>
                  <dt>Jurisdiction</dt>
                  <dd>{item.jurisdiction}</dd>
                </div>
                {item.category && (
                  <div>
                    <dt>Category</dt>
                    <dd>{item.category}</dd>
                  </div>
                )}
                {item.citation && (
                  <div>
                    <dt>Citation / ID</dt>
                    <dd>{item.citation}</dd>
                  </div>
                )}
                {item.access && (
                  <div>
                    <dt>Access</dt>
                    <dd>{item.access}</dd>
                  </div>
                )}
                <div>
                  <dt>Status / provenance</dt>
                  <dd>
                    <span className="legal-reference-review">
                      {item.status === "imported-unverified"
                        ? "Imported unverified material"
                        : item.status || "Review required"}
                    </span>{" "}
                    · {item.source}
                    {item.sourceLine ? ` · source line ${item.sourceLine}` : ""}
                  </dd>
                </div>
                {item.related?.length > 0 && (
                  <div>
                    <dt>Related terms</dt>
                    <dd>{item.related.join(" · ")}</dd>
                  </div>
                )}
                {item.treatment && (
                  <div>
                    <dt>Editorial note</dt>
                    <dd>{item.treatment}</dd>
                  </div>
                )}
              </dl>
              {item.sourceUrl && (
                <a
                  className="legal-reference-source"
                  href={item.sourceUrl}
                  target="_blank"
                  rel="noreferrer"
                >
                  <LegalReferenceIcon name="external" />
                  Open official source
                </a>
              )}
              <label className="legal-reference-note">
                <span className="control-label">
                  <LegalReferenceIcon name="note" />
                  Private annotation
                </span>
                <textarea
                  value={notes[id] || ""}
                  onChange={(e) => persistNote(id, e.target.value)}
                  placeholder="Add a research note…"
                />
              </label>
            </article>
          );
        })}
        {activeRecords.length === 0 && (
          <div className="legal-reference-empty">
            <strong>No matching records.</strong>
            <span>Clear filters or try a broader spelling.</span>
            <button
              onClick={() => {
                setQuery("");
                setLetter("ALL");
                setDomain("All domains");
                setJurisdiction("All jurisdictions");
                resetPage();
              }}
            >
              <LegalReferenceIcon name="clear" />
              Clear all filters
            </button>
          </div>
        )}
      </section>
      {activeRecords.length > pageSize && (
        <nav className="legal-reference-pagination" aria-label="Result pages">
          <button
            disabled={page === 1}
            onClick={() => {
              setPage((value) => value - 1);
              contentRef.current?.focus();
            }}
          >
            <LegalReferenceIcon name="previous" />
            Previous page
          </button>
          <span>
            Page {page} of {pageCount}
          </span>
          <button
            disabled={page === pageCount}
            onClick={() => {
              setPage((value) => value + 1);
              contentRef.current?.focus();
            }}
          >
            Next page
            <LegalReferenceIcon name="next" />
          </button>
        </nav>
      )}
      <div className="sr-only" aria-live="polite">
        {message}
      </div>
    </div>
  );
}
