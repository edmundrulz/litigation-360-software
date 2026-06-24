@echo off
echo ====================================
echo Litigation 360 - Language Audit Only
echo No deletion will be performed
echo ====================================

if not exist reports mkdir reports
if not exist reports\phase7c mkdir reports\phase7c

echo Scanning backend language references...
findstr /S /I /N "bahasa malaysia bm mandarin chinese tamil translation locale i18n multilingual language" backend\src\*.js > reports\phase7c\LANGUAGE-AUDIT-BACKEND.txt

echo Scanning frontend language references...
findstr /S /I /N "bahasa malaysia bm mandarin chinese tamil translation locale i18n multilingual language" frontend\src\*.* > reports\phase7c\LANGUAGE-AUDIT-FRONTEND.txt

echo Creating English-only policy report...
(
echo # Litigation 360 Language Audit Report
echo.
echo Status: REVIEW ONLY
echo.
echo No files deleted.
echo No code modified.
echo.
echo Policy:
echo - Litigation 360 production interface shall use English only.
echo - Non-English templates, labels, messages, or locale systems require explicit approval.
echo - Backup folders are excluded from deletion until Phase 8 is completed.
echo.
echo Generated files:
echo - LANGUAGE-AUDIT-BACKEND.txt
echo - LANGUAGE-AUDIT-FRONTEND.txt
) > reports\phase7c\LANGUAGE-AUDIT-REPORT.md

echo.
echo Language audit completed.
echo Check:
echo reports\phase7c\LANGUAGE-AUDIT-BACKEND.txt
echo reports\phase7c\LANGUAGE-AUDIT-FRONTEND.txt
echo reports\phase7c\LANGUAGE-AUDIT-REPORT.md
echo.

pause