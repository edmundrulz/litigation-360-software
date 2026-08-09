const WORKFLOW_PAGES = [
  { number: 1, title: "Preliminary Assessment & Triage", module: "Client Intake Discovery" },
  { number: 2, title: "Matter Intake", module: "Matter Intake" },
  { number: 3, title: "Client Details", module: "Clients" },
  { number: 4, title: "Case / Matter Details", module: "Cases" },
  { number: 5, title: "Court Dates", module: "Court Dates" },
  { number: 6, title: "Documents & Evidence", module: "Documents" },
  { number: 7, title: "Draft Engagement Preview", module: "Review Submit" },
];

export default function WorkflowPageNavigation({
  position,
  pages = WORKFLOW_PAGES,
  currentPageId,
  onNavigate,
  onPrevious,
  onHome,
  onContinue,
  onGoToTop,
  onGoToBottom,
}) {
  const availablePages = Array.isArray(pages) ? pages : [];
  const isBottom = position === "bottom";
  const destinationPages = availablePages.filter(
    (page) => page?.title !== currentPageId && page?.module !== currentPageId,
  );

  function handleDestinationChange(event) {
    const selectedNumber = event.target.value;
    if (!selectedNumber) return;

    const destination = destinationPages.find(
      (page) => String(page.number) === selectedNumber,
    );
    if (destination && typeof onNavigate === "function") {
      onNavigate(destination.module);
    }
  }

  return (
    <nav
      className={`module-page-nav module-page-nav-${position}`}
      aria-label={`${position} workflow page navigation`}
    >
      <button
        type="button"
        className="module-page-nav-button module-page-nav-previous"
        onClick={onPrevious}
        disabled={typeof onPrevious !== "function"}
        title="Previous Step / Page"
      >← Previous Step / Page</button>

      <button
        type="button"
        className="module-page-nav-button module-page-nav-home"
        onClick={onHome}
        disabled={typeof onHome !== "function"}
        title="Home Main Page"
      >Home Main Page</button>

      {isBottom && (
        <label className="module-page-nav-direct">
          <span>Go to page</span>
          <select
            value=""
            aria-label="Go directly to workflow page"
            onChange={handleDestinationChange}
            disabled={destinationPages.length === 0 || typeof onNavigate !== "function"}
          >
            <option value="" disabled>Select another page</option>
            {destinationPages.map((page) => (
              <option key={page.number} value={page.number}>
                Page {page.number}: {page.title}
              </option>
            ))}
          </select>
        </label>
      )}

      <button
        type="button"
        className="module-page-nav-button module-page-nav-next"
        onClick={onContinue}
        disabled={typeof onContinue !== "function"}
        title="Continue to Next Step / Page"
      >Continue to Next Step / Page →</button>

      <button
        type="button"
        className="module-page-nav-button module-page-nav-jump"
        onClick={isBottom ? onGoToTop : onGoToBottom}
        disabled={typeof (isBottom ? onGoToTop : onGoToBottom) !== "function"}
        title={isBottom ? "Go to Top of Page" : "Go to Bottom/End of Page"}
      >
        {isBottom ? "Go to Top of Page ↑" : "Go to Bottom/End of Page ↓"}
      </button>
    </nav>
  );
}
