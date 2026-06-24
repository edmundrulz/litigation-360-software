# Litigation 360 Enterprise Operations SOP

Generated: 06/20/2026 12:35:05

## Purpose

This SOP defines how Litigation 360 is operated, checked, maintained, recovered, and escalated.

## Daily Startup Checklist

1. Confirm backend starts without error.
2. Confirm frontend starts without error.
3. Confirm database connection works.
4. Confirm route inventory exists.
5. Confirm automation inventory exists.
6. Confirm no oversized generated report exists.
7. Confirm dashboard loads.
8. Confirm user login works.

## Daily Shutdown Checklist

1. Stop backend safely.
2. Stop frontend safely.
3. Confirm no stuck PowerShell/node process.
4. Confirm no generated CSV is open/locked.
5. Confirm latest reports are saved.

## Incident Procedure

If scanner hangs or CSV grows abnormally:

1. Stop the running command using Ctrl + C.
2. Close Excel, Notepad, and File Explorer preview pane.
3. Kill stuck PowerShell/node process only if required.
4. Delete corrupted oversized output.
5. Rerun safe scanner version.
6. Confirm output size is reasonable.

## Report Size Rules

| Report | Expected Size |
|---|---:|
| RouteInventory.csv | KB to low MB |
| DatabaseInventory.csv | KB to low MB |
| AutomationInventory.csv | KB to low MB |
| AllFiles.csv | May be large |

Any database or automation report above 100MB requires investigation.

## Escalation Rule

Do not proceed to new feature development if:

- routes are not inventoried
- database inventory is missing
- automation inventory is missing
- architecture map is missing
- SOP is missing
- scanner output is corrupted

## Phase 10ZZ.2 Status

Enterprise SOP recovery started.
