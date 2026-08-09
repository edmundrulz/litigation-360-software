const paths = {
  dictionary: (
    <>
      <path d="M4 5.5A3.5 3.5 0 0 1 7.5 2H11v17H7.5A3.5 3.5 0 0 0 4 22z" />
      <path d="M20 5.5A3.5 3.5 0 0 0 16.5 2H13v17h3.5A3.5 3.5 0 0 1 20 22z" />
    </>
  ),
  legislation: (
    <>
      <path d="M12 3v18M5 6h14M7 6l-4 7h8L7 6Zm10 0-4 7h8l-4-7Z" />
      <path d="M3 13c0 2 2 3 4 3s4-1 4-3m2 0c0 2 2 3 4 3s4-1 4-3" />
    </>
  ),
  search: (
    <>
      <circle cx="11" cy="11" r="7" />
      <path d="m20 20-4-4" />
    </>
  ),
  filter: <path d="M3 5h18l-7 8v6l-4 2v-8z" />,
  bookmark: <path d="M6 3h12v18l-6-4-6 4z" />,
  note: (
    <>
      <path d="M4 4h16v16H4z" />
      <path d="M8 9h8M8 13h6" />
    </>
  ),
  export: (
    <>
      <path d="M12 3v12m-4-4 4 4 4-4" />
      <path d="M5 19h14" />
    </>
  ),
  print: (
    <>
      <path d="M7 8V3h10v5M7 17H4v-7h16v7h-3" />
      <path d="M7 14h10v7H7z" />
    </>
  ),
  copy: (
    <>
      <rect x="8" y="8" width="12" height="12" rx="2" />
      <path d="M16 8V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h3" />
    </>
  ),
  share: (
    <>
      <circle cx="18" cy="5" r="2" />
      <circle cx="6" cy="12" r="2" />
      <circle cx="18" cy="19" r="2" />
      <path d="m8 11 8-5M8 13l8 5" />
    </>
  ),
  import: (
    <>
      <path d="M12 21V9m-4 4 4-4 4 4" />
      <path d="M5 5h14" />
    </>
  ),
  clear: (
    <>
      <path d="m6 6 12 12M18 6 6 18" />
    </>
  ),
  previous: <path d="m15 18-6-6 6-6" />,
  next: <path d="m9 18 6-6-6-6" />,
  all: (
    <>
      <path d="M4 6h16M4 12h16M4 18h16" />
    </>
  ),
  external: (
    <>
      <path d="M14 3h7v7M21 3l-9 9" />
      <path d="M18 13v7H4V6h7" />
    </>
  ),
  saved: (
    <path d="m12 3 2.7 5.5 6.1.9-4.4 4.3 1 6.1-5.4-2.9-5.4 2.9 1-6.1-4.4-4.3 6.1-.9z" />
  ),
  reset: (
    <>
      <path d="M4 4v6h6" />
      <path d="M5.5 15a8 8 0 1 0 1-8.5L4 10" />
    </>
  ),
  collection: (
    <>
      <path d="M5 3h14v18l-7-4-7 4z" />
      <path d="M9 8h6" />
    </>
  ),
  registry: (
    <>
      <path d="M3 21h18M5 18V8h14v10M8 8V5h8v3" />
      <path d="M8 12h2m4 0h2m-8 3h2m4 0h2" />
    </>
  ),
};
export default function LegalReferenceIcon({ name, size = 18 }) {
  return (
    <svg
      aria-hidden="true"
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.8"
      strokeLinecap="round"
      strokeLinejoin="round"
      focusable="false"
    >
      {paths[name] || paths.all}
    </svg>
  );
}
