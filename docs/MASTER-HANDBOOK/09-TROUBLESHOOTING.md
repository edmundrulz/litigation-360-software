# 09 Troubleshooting Guide

## Backend Connection Refused
Meaning: backend is not running on port 5000.
Fix:
cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend
npm start

## Frontend Port 5173 In Use
Meaning: Vite selected another port.
Fix: open the exact Vite URL shown, usually 5174.

## npm run build Fails
Meaning: frontend has syntax, import, or build issue.
Fix: stop deployment and run rollback script for the current phase.

## PowerShell Here-String Error
Meaning: script was pasted incompletely or terminator was missing.
Fix: replace the script fully, do not patch line by line.

## BAT File Not Recognized
Meaning: file name or folder is wrong.
Fix: run dir *.bat and confirm exact filename.
