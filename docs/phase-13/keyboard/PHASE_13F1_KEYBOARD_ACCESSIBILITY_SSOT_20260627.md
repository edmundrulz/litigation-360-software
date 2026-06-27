# Litigation 360 / LEOS 360
# Phase 13F.1 Keyboard Accessibility + Shortcut Framework SSOT

Date: 2026-06-27

## Purpose

Create a controlled frontend-only keyboard accessibility and shortcut framework.

## Scope

Frontend only.

## Approved Behaviours

- Enter confirms or submits app-owned actions.
- Escape closes or cancels app-owned modals, drawers, menus, searches, and command states.
- Tab and Shift+Tab should follow logical native focus order.
- Arrow keys support app-owned menus, dropdowns, lists, tables, and selection widgets.
- Ctrl/Cmd+S may trigger app save where a save action exists.
- Ctrl/Cmd+C, Ctrl/Cmd+V, Ctrl/Cmd+X, Ctrl/Cmd+Z, and Ctrl/Cmd+A must remain native inside text fields.
- Home, End, PageUp, and PageDown should work only where the app owns list/table/panel navigation.
- Visible focus indicators must be present.
- Keyboard shortcut help / cheat sheet must be added or documented.

## Forbidden

Do not modify backend, database, auth, RBAC, API routes, server files, migrations, package files, or production infrastructure logic.

## Status

Phase 13F.1 Status: PLANNING CREATED
Implementation Status: NOT STARTED
