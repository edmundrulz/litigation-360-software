/*
  L360 / LEOS Frontend Status Clarity Injector
  Phase: 13B
  Scope: frontend-only status clarity

  Safe version:
  - no JavaScript template literals
  - no ${...} placeholders
  - no backend calls
  - no RBAC/auth/database/package/env changes
*/

(function () {
  'use strict';

  var STATUS_ID = 'l360-phase13b-status-clarity';
  var STYLE_ID = 'l360-phase13b-status-clarity-style';

  function install() {
    if (typeof document === 'undefined') {
      return;
    }

    if (document.getElementById(STATUS_ID)) {
      return;
    }

    if (!document.getElementById(STYLE_ID)) {
      var style = document.createElement('style');
      style.id = STYLE_ID;
      style.textContent = [
        '#' + STATUS_ID + ' {',
        '  position: fixed;',
        '  right: 16px;',
        '  bottom: 16px;',
        '  z-index: 2147483000;',
        '  max-width: 420px;',
        '  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;',
        '  background: rgba(18, 24, 38, 0.96);',
        '  color: #ffffff;',
        '  border: 1px solid rgba(255, 255, 255, 0.18);',
        '  border-radius: 14px;',
        '  box-shadow: 0 12px 36px rgba(0, 0, 0, 0.30);',
        '  padding: 12px 14px;',
        '  line-height: 1.35;',
        '}',
        '#' + STATUS_ID + ' .l360-title {',
        '  font-size: 13px;',
        '  font-weight: 800;',
        '  letter-spacing: 0.02em;',
        '  margin-bottom: 6px;',
        '}',
        '#' + STATUS_ID + ' .l360-row {',
        '  font-size: 12px;',
        '  opacity: 0.94;',
        '  margin: 3px 0;',
        '}',
        '#' + STATUS_ID + ' .l360-pill {',
        '  display: inline-block;',
        '  font-size: 11px;',
        '  font-weight: 700;',
        '  padding: 2px 7px;',
        '  margin-left: 5px;',
        '  border-radius: 999px;',
        '  background: rgba(255, 255, 255, 0.14);',
        '}',
        '#' + STATUS_ID + ' button {',
        '  position: absolute;',
        '  top: 6px;',
        '  right: 8px;',
        '  border: 0;',
        '  background: transparent;',
        '  color: #ffffff;',
        '  cursor: pointer;',
        '  font-size: 16px;',
        '  line-height: 1;',
        '  opacity: 0.72;',
        '}',
        '#' + STATUS_ID + ' button:hover {',
        '  opacity: 1;',
        '}',
        '@media (max-width: 640px) {',
        '  #' + STATUS_ID + ' {',
        '    left: 10px;',
        '    right: 10px;',
        '    bottom: 10px;',
        '    max-width: none;',
        '  }',
        '}'
      ].join('\n');

      document.head.appendChild(style);
    }

    var panel = document.createElement('aside');
    panel.id = STATUS_ID;
    panel.setAttribute('role', 'status');
    panel.setAttribute('aria-label', 'Litigation 360 operational status');

    var closeButton = document.createElement('button');
    closeButton.type = 'button';
    closeButton.setAttribute('aria-label', 'Hide status panel');
    closeButton.title = 'Hide';
    closeButton.textContent = '×';
    closeButton.addEventListener('click', function () {
      panel.remove();
    });

    var title = document.createElement('div');
    title.className = 'l360-title';
    title.innerHTML = 'L360 / LEOS Operational Status <span class="l360-pill">Phase 13B</span>';

    var rows = [
      'Cleanroom cutover: <strong>MAIN promoted</strong>',
      'Documents: <strong>metadata-only</strong>',
      'RBAC: <strong>parked</strong>',
      'Phase 11: <strong>locked</strong> · Production rollout: <strong>blocked</strong>',
      'Scope: frontend status clarity only; no backend logic changed.'
    ];

    panel.appendChild(closeButton);
    panel.appendChild(title);

    rows.forEach(function (text) {
      var row = document.createElement('div');
      row.className = 'l360-row';
      row.innerHTML = text;
      panel.appendChild(row);
    });

    document.body.appendChild(panel);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', install);
  } else {
    install();
  }
})();
