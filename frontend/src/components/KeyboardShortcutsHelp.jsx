import React from "react";

const SHORTCUT_GROUPS = [
  {
    title: "Application shortcuts",
    shortcuts: [
      ["?", "Open keyboard shortcut help"],
      ["Esc", "Close this help panel"],
      ["Ctrl/Cmd + S", "Trigger the app save shortcut placeholder when not typing"],
      ["Alt + Shift + H", "Return to main workspace"],
      ["Alt + Shift + 1", "Open End User Workspace"],
      ["Alt + Shift + 2", "Open Operations Centre"],
      ["Alt + Shift + 3", "Open Admin Centre"],
      ["Alt + Shift + 4", "Open Developer Centre"]
    ]
  },
  {
    title: "Native keyboard behaviour preserved",
    shortcuts: [
      ["Tab / Shift + Tab", "Move through focusable controls in browser order"],
      ["Enter / Space", "Activate the focused button or submit the active form"],
      ["Arrow keys", "Navigate app-owned menus, lists, dropdowns, and text fields"],
      ["Backspace / Delete", "Edit text normally inside fields"],
      ["Home / End", "Move within text fields or browser-owned areas"],
      ["Page Up / Page Down", "Scroll browser-owned pages and panels"],
      ["Ctrl/Cmd + C/V/X/Z/A", "Copy, paste, cut, undo, and select all remain native inside fields"]
    ]
  }
];

export default function KeyboardShortcutsHelp({ open, onClose }) {
  if (!open) return null;

  return (
    <div className="keyboard-shortcuts-overlay" role="presentation">
      <section
        className="keyboard-shortcuts-dialog"
        role="dialog"
        aria-modal="true"
        aria-labelledby="keyboard-shortcuts-title"
      >
        <div className="keyboard-shortcuts-header">
          <div>
            <p className="eyebrow">Accessibility</p>
            <h2 id="keyboard-shortcuts-title">Keyboard Shortcuts</h2>
          </div>

          <button type="button" onClick={onClose} autoFocus>
            Close
          </button>
        </div>

        <p className="keyboard-shortcuts-note">
          Shortcuts are only handled when the app owns the action. Text editing,
          browser shortcuts, and operating-system shortcuts are preserved wherever possible.
        </p>

        <div className="keyboard-shortcuts-grid">
          {SHORTCUT_GROUPS.map((group) => (
            <article className="keyboard-shortcuts-card" key={group.title}>
              <h3>{group.title}</h3>

              <dl>
                {group.shortcuts.map(([keys, description]) => (
                  <div key={keys}>
                    <dt><kbd>{keys}</kbd></dt>
                    <dd>{description}</dd>
                  </div>
                ))}
              </dl>
            </article>
          ))}
        </div>
      </section>
    </div>
  );
}
