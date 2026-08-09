import { useEffect, useMemo, useRef, useState } from "react";
import { createPortal } from "react-dom";
import { menuSections as defaultMenuSections } from "./menuConfig";
import {
  filterMenuItems,
  isMenuItemEnabled,
} from "./menuSchema";
import { FaqPanel } from "./panels/FaqPanel";
import { SupportRequestPanel } from "./panels/SupportRequestPanel";
import {
  AboutAppPanel,
  AboutSystemPanel,
  RecentFilesPanel,
  SettingsPanel,
  SystemPanel,
} from "./panels/InfoPanels";
import {
  FileExportPanel,
  FileImportPanel,
  FileOpenPanel,
  FileSavePanel,
} from "./panels/FileActionPanels";
import LegalFooter from "../../components/LegalFooter";
import "./MenuPlatform.css";

const ICON_PATHS = {
  file: ["M6 2h8l4 4v16H6z", "M14 2v5h5"],
  "folder-open": ["M3 7h7l2 2h9v11H3z"],
  save: ["M5 3h13l2 2v16H4V3z", "M8 3v6h8V3", "M8 21v-7h8v7"],
  import: ["M12 3v12", "M7 10l5 5 5-5", "M4 21h16"],
  export: ["M12 15V3", "M7 8l5-5 5 5", "M4 21h16"],
  clock: ["M12 7v5l3 2", "M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18"],
  cpu: ["M9 9h6v6H9z", "M9 2v3", "M15 2v3", "M9 19v3", "M15 19v3", "M2 9h3", "M2 15h3", "M19 9h3", "M19 15h3"],
  settings: ["M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8z", "M12 2v3", "M12 19v3", "M2 12h3", "M19 12h3", "M5 5l2 2", "M17 17l2 2", "M19 5l-2 2", "M7 17l-2 2"],
  "help-circle": ["M9.5 9a2.5 2.5 0 1 1 4.1 1.9c-.9.8-1.6 1.3-1.6 2.6", "M12 17h.01", "M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18"],
  "message-square": ["M4 4h16v12H8l-4 4z"],
  info: ["M12 11v5", "M12 8h.01", "M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18"],
  monitor: ["M4 4h16v12H4z", "M8 20h8", "M12 16v4"],
  search: ["M11 4a7 7 0 1 0 0 14 7 7 0 0 0 0-14", "M16 16l4 4"],
  expand: ["M8 3H3v5", "M3 3l6 6", "M16 3h5v5", "M21 3l-6 6", "M3 16v5h5", "M3 21l6-6", "M21 16v5h-5", "M21 21l-6-6"],
  restore: ["M8 3h13v13", "M16 8l5-5", "M3 8h13v13", "M8 16l-5 5"],
  close: ["M6 6l12 12", "M18 6L6 18"],
  chevron: ["M8 10l4 4 4-4"],
};

const PANEL_COMPONENTS = {
  "file-open": FileOpenPanel,
  "file-save": FileSavePanel,
  "file-import": FileImportPanel,
  "file-export": FileExportPanel,
  faq: FaqPanel,
  "submit-request": SupportRequestPanel,
  "about-app": AboutAppPanel,
  "about-system": AboutSystemPanel,
  settings: SettingsPanel,
  system: SystemPanel,
  "file-recent": RecentFilesPanel,
  "legal-notice": LegalNoticePanel,
};

function LegalNoticePanel() {
  return <LegalFooter variant="panel" />;
}

function MenuIcon({ name }) {
  const paths = ICON_PATHS[name] || ICON_PATHS.info;
  return (
    <span className="mp-item-icon" aria-hidden="true">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" focusable="false">
        {paths.map((path, index) => <path key={`${name}-${index}`} d={path} />)}
      </svg>
    </span>
  );
}

function MenuBadge({ children }) {
  if (!children) return null;
  return <span className="mp-badge">{children}</span>;
}

function Shortcut({ value }) {
  if (!value) return null;
  return <kbd className="mp-shortcut">{value}</kbd>;
}

function MenuItemButton({
  item,
  depth = 0,
  expanded = false,
  active = false,
  disabled = false,
  onSelect,
  onToggle,
}) {
  const hasChildren = item.children?.length > 0;
  const isSubmenu = item.type === "submenu" && hasChildren;

  function handleClick() {
    if (disabled) return;

    if (isSubmenu) {
      onToggle?.(item.id);
      return;
    }

    onSelect?.(item);
  }

  if (item.type === "separator") {
    return <div className="mp-separator" role="separator" />;
  }

  return (
    <button
      type="button"
      data-menu-row="true"
      className={`mp-menu-item ${active ? "is-active" : ""}`}
      style={{ "--mp-depth": depth }}
      aria-label={item.ariaLabel || item.label}
      aria-disabled={disabled ? "true" : undefined}
      aria-haspopup={isSubmenu ? "menu" : undefined}
      aria-expanded={isSubmenu ? expanded : undefined}
      disabled={disabled}
      title={disabled ? "Unavailable in the current context" : undefined}
      onClick={handleClick}
    >
      <MenuIcon name={item.icon} />

      <span className="mp-item-main">
        <span className="mp-item-label">{item.label}</span>
        {item.trail?.length > 1 ? (
          <small className="mp-item-trail">
            {item.trail.slice(0, -1).join(" / ")}
          </small>
        ) : null}
      </span>

      <MenuBadge>{item.badge}</MenuBadge>
      <Shortcut value={item.shortcut} />

      {isSubmenu ? (
        <span className="mp-expand-indicator" aria-hidden="true">
          <svg className={expanded ? "is-expanded" : ""} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" focusable="false"><path d="M8 10l4 4 4-4" /></svg>
        </span>
      ) : null}
    </button>
  );
}

function MenuTree({
  items,
  depth = 0,
  expandedIds,
  setExpandedIds,
  onSelect,
  featureFlags,
  activePanelId,
}) {
  function toggle(id) {
    setExpandedIds((current) => {
      const next = new Set(current);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }

  return (
    <div className="mp-menu-tree" role={depth === 0 ? undefined : "group"}>
      {items.map((item) => {
        const disabled = !isMenuItemEnabled(item, featureFlags);
        const expanded = expandedIds.has(item.id);
        const hasChildren = item.children?.length > 0;

        return (
          <div className="mp-menu-node" key={item.id}>
            <MenuItemButton
              item={item}
              depth={depth}
              expanded={expanded}
              active={activePanelId === item.id}
              disabled={disabled}
              onSelect={onSelect}
              onToggle={toggle}
            />

            {hasChildren && expanded && depth < 2 ? (
              <MenuTree
                items={item.children}
                depth={depth + 1}
                expandedIds={expandedIds}
                setExpandedIds={setExpandedIds}
                onSelect={onSelect}
                featureFlags={featureFlags}
                activePanelId={activePanelId}
              />
            ) : null}
          </div>
        );
      })}
    </div>
  );
}

function PanelHost({ panelId, appVersion }) {
  if (!panelId) {
    return (
      <section className="mp-panel mp-panel-placeholder">
        <h2>Menu Hub</h2>
        <p>
          Select FAQ, Settings, About App, About System, or Submit Query /
          Request from the left menu.
        </p>
      </section>
    );
  }

  const Panel = PANEL_COMPONENTS[panelId];

  if (!Panel) {
    return (
      <section className="mp-panel">
        <h2>Action Ready</h2>
        <p>This item is ready for route, command, or integration wiring.</p>
      </section>
    );
  }

  return <Panel appVersion={appVersion} />;
}

export function MenuPlatform({
  sections = defaultMenuSections,
  context = "global",
  appVersion = "0.0.0",
  triggerLabel = "Menu",
  triggerVariant = "sidebar",
  featureFlags = {},
  onNavigate,
  onAction,
}) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [activePanelId, setActivePanelId] = useState("");
  const [expandedIds, setExpandedIds] = useState(new Set(["file"]));
  const [announcement, setAnnouncement] = useState("");
  const [fullscreen, setFullscreen] = useState(false);
  const rootRef = useRef(null);
  const triggerRef = useRef(null);
  const searchRef = useRef(null);
  const shellRef = useRef(null);
  const menuColumnRef = useRef(null);

  const searchResults = useMemo(
    () => filterMenuItems(sections, query, { context, featureFlags }),
    [sections, query, context, featureFlags]
  );

  const orderedSections = useMemo(
    () => [...sections].sort((a, b) => a.priority - b.priority),
    [sections]
  );

  useEffect(() => {
    if (!open) return;

    const timer = setTimeout(() => {
      searchRef.current?.focus();
    }, 0);

    return () => clearTimeout(timer);
  }, [open]);

  useEffect(() => {
    if (!open) return;

    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";

    return () => {
      document.body.style.overflow = previousOverflow;
    };
  }, [open]);

  useEffect(() => {
    function handleOpenEvent(event) {
      if (event.detail?.source !== rootRef.current && open) {
        setOpen(false);
        setQuery("");
      }
    }

    window.addEventListener("mp:menu-opened", handleOpenEvent);
    return () => window.removeEventListener("mp:menu-opened", handleOpenEvent);
  }, [open]);

  useEffect(() => {
    if (!open) return;
    window.dispatchEvent(
      new CustomEvent("mp:menu-opened", { detail: { source: rootRef.current } })
    );
  }, [open]);

  function closeMenu() {
    setOpen(false);
    setQuery("");
    setFullscreen(false);
    triggerRef.current?.focus();
  }

  useEffect(() => {
    if (!open || typeof window === "undefined") return;

    const scrollX = window.scrollX;
    const scrollY = window.scrollY;

    window.requestAnimationFrame(() => {
      shellRef.current?.scrollTo({ top: 0, left: 0 });
      menuColumnRef.current?.scrollTo({ top: 0, left: 0 });

      try {
        searchRef.current?.focus({ preventScroll: true });
      } catch {
        searchRef.current?.focus();
      }

      window.scrollTo(scrollX, scrollY);
    });
  }, [open]);

  function handleSelect(item) {
    if (!isMenuItemEnabled(item, featureFlags)) return;

    if (item.type === "panel") {
      setActivePanelId(item.id);
      setAnnouncement(`${item.label} panel opened.`);
      return;
    }

    if (item.type === "link" && item.href) {
      window.location.assign(item.href);
      return;
    }

    if (item.id === "home") {
      onNavigate?.("home");
      setAnnouncement("Home selected.");
      closeMenu();
      return;
    }

    onAction?.(item);
    setAnnouncement(`${item.label} selected.`);
  }

  function getRows() {
    return Array.from(shellRef.current?.querySelectorAll("[data-menu-row='true']") || []).filter(
      (row) => !row.disabled
    );
  }

  function focusRelativeRow(offset) {
    const rows = getRows();
    if (rows.length === 0) return;

    const currentIndex = rows.indexOf(document.activeElement);
    const nextIndex =
      currentIndex === -1
        ? 0
        : (currentIndex + offset + rows.length) % rows.length;

    rows[nextIndex]?.focus();
  }

  function handleKeyDown(event) {
    if (event.key === "Tab") {
      const focusable = Array.from(shellRef.current?.querySelectorAll('button:not([disabled]), input:not([disabled]), [href], select:not([disabled]), textarea:not([disabled])') || []);
      if (focusable.length) {
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
        if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
      }
      return;
    }
    switch (event.key) {
      case "Escape":
        event.preventDefault();
        closeMenu();
        break;
      case "ArrowDown":
        event.preventDefault();
        focusRelativeRow(1);
        break;
      case "ArrowUp":
        event.preventDefault();
        focusRelativeRow(-1);
        break;
      case "Enter":
      case " ":
        if (document.activeElement?.dataset?.menuRow === "true") {
          event.preventDefault();
          document.activeElement.click();
        }
        break;
      default:
        break;
    }
  }

  const overlay =
    open && typeof document !== "undefined"
      ? createPortal(
          <>
            <button
              type="button"
              className="mp-backdrop"
              aria-label="Close application menu"
              onClick={closeMenu}
              tabIndex={-1}
            />

            <section
              id="mp-dropdown-shell"
              ref={shellRef}
              className={`mp-dropdown-shell ${fullscreen ? "is-fullscreen" : ""}`}
              role="dialog"
              aria-modal="true"
              aria-labelledby="mp-menu-title"
              onKeyDown={handleKeyDown}
            >
              <header className="mp-window-header">
                <div>
                  <h2 id="mp-menu-title">Application Menu</h2>
                  <p>Workspace actions, preferences, legal notices and support.</p>
                </div>
                <div className="mp-window-controls">
                  <button type="button" className="mp-window-control" aria-label={fullscreen ? "Restore menu size" : "Expand menu to full screen"} title={fullscreen ? "Restore menu size" : "Expand menu to full screen"} onClick={() => setFullscreen((current) => !current)}>
                    <MenuIcon name={fullscreen ? "restore" : "expand"} />
                  </button>
                  <button
                type="button"
                className="mp-menu-close-corner"
                aria-label="Close application menu"
                title="Close menu"
                onClick={closeMenu}
              >
                <MenuIcon name="close" />
              </button>
                </div>
              </header>
<div className="mp-menu-column" ref={menuColumnRef}>
                <label className="mp-search">
                  <span className="mp-visually-hidden">Search menu</span>
                  <MenuIcon name="search" />
                  <input
                    ref={searchRef}
                    value={query}
                    onChange={(event) => setQuery(event.target.value)}
                    placeholder="Search menu"
                    aria-label="Search menu, settings, FAQ, and support topics"
                  />
                </label>

                {query ? (
                  <div className="mp-search-results">
                    <div className="mp-section-title">Search Results</div>
                    {searchResults.length > 0 ? (
                      searchResults.map((item) => (
                        <MenuItemButton
                          key={`${item.sectionId}-${item.id}`}
                          item={item}
                          active={activePanelId === item.id}
                          disabled={!isMenuItemEnabled(item, featureFlags)}
                          onSelect={handleSelect}
                        />
                      ))
                    ) : (
                      <p className="mp-empty">No matching menu item found.</p>
                    )}
                  </div>
                ) : (
                  orderedSections.map((section) => (
                    <section className="mp-section" key={section.id}>
                      <div className="mp-section-title">{section.title}</div>
                      <MenuTree
                        items={section.items}
                        expandedIds={expandedIds}
                        setExpandedIds={setExpandedIds}
                        onSelect={handleSelect}
                        featureFlags={featureFlags}
                        activePanelId={activePanelId}
                      />
                    </section>
                  ))
                )}
              </div>

              <div className="mp-panel-column">
                <PanelHost panelId={activePanelId} appVersion={appVersion} />
              </div>

              <div className="mp-live-region" aria-live="polite">
                {announcement}
              </div>
            </section>
          </>,
          document.body
        )
      : null;

  return (
    <div className={`mp-root mp-trigger-${triggerVariant}`} ref={rootRef}>
      <button
        type="button"
        ref={triggerRef}
        className="mp-trigger"
        aria-haspopup="dialog"
        aria-expanded={open}
        aria-controls="mp-dropdown-shell"
        onClick={() => setOpen((current) => !current)}
      >
        <MenuIcon name="file" />
        <span>{triggerLabel}</span>
      </button>

      {overlay}
    </div>
  );
}
