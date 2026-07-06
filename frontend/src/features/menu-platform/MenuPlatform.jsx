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

const ICONS = {
  home: "⌂",
  file: "▣",
  "folder-open": "▤",
  save: "▥",
  import: "⇣",
  export: "⇡",
  clock: "◷",
  cpu: "▧",
  settings: "⚙",
  "help-circle": "?",
  "message-square": "✉",
  info: "i",
  monitor: "▭",
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

function getIcon(name) {
  return ICONS[name] || "•";
}

function MenuIcon({ name }) {
  return (
    <span className="mp-item-icon" aria-hidden="true">
      {getIcon(name)}
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
          {expanded ? "⌄" : "›"}
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
  const rootRef = useRef(null);
  const triggerRef = useRef(null);
  const searchRef = useRef(null);
  const shellRef = useRef(null);

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
    triggerRef.current?.focus();
  }

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
              className="mp-dropdown-shell"
              role="dialog"
              aria-modal="true"
              aria-label="Application menu"
              onKeyDown={handleKeyDown}
            >
              <div className="mp-menu-column">
                <label className="mp-search">
                  <span className="mp-visually-hidden">Search menu</span>
                  <input
                    ref={searchRef}
                    value={query}
                    onChange={(event) => setQuery(event.target.value)}
                    placeholder="Search menu, settings, FAQ..."
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
        <span aria-hidden="true">☰</span>
        <span>{triggerLabel}</span>
      </button>

      {overlay}
    </div>
  );
}
