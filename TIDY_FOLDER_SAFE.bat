@echo off
setlocal enabledelayedexpansion

title Laptop Folder Auto Tidy

echo ==========================================
echo LAPTOP FILE TIDY SCRIPT
echo ==========================================
echo.

set "SOURCE=%~1"

if "%SOURCE%"=="" (
    set /p SOURCE=Drag/drop or type the folder path to tidy: 
)

if not exist "%SOURCE%" (
    echo ERROR: Folder does not exist.
    pause
    exit /b
)

echo.
echo Target folder:
echo %SOURCE%
echo.

set /p CONFIRM=Proceed to organize this folder? Type YES to continue: 

if /I not "%CONFIRM%"=="YES" (
    echo Cancelled.
    pause
    exit /b
)

cd /d "%SOURCE%"

mkdir "01_Documents" 2>nul
mkdir "02_PDFs" 2>nul
mkdir "03_Images" 2>nul
mkdir "04_Videos" 2>nul
mkdir "05_Audio" 2>nul
mkdir "06_Spreadsheets" 2>nul
mkdir "07_Presentations" 2>nul
mkdir "08_Archives" 2>nul
mkdir "09_Installers" 2>nul
mkdir "10_Code" 2>nul
mkdir "11_Scans" 2>nul
mkdir "12_Others" 2>nul

echo Organizing files...
echo.

for %%F in (*.*) do (
    if /I not "%%~nxF"=="%~nx0" (

        set "EXT=%%~xF"

        if /I "!EXT!"==".doc" move "%%F" "01_Documents\"
        if /I "!EXT!"==".docx" move "%%F" "01_Documents\"
        if /I "!EXT!"==".txt" move "%%F" "01_Documents\"
        if /I "!EXT!"==".rtf" move "%%F" "01_Documents\"

        if /I "!EXT!"==".pdf" move "%%F" "02_PDFs\"

        if /I "!EXT!"==".jpg" move "%%F" "03_Images\"
        if /I "!EXT!"==".jpeg" move "%%F" "03_Images\"
        if /I "!EXT!"==".png" move "%%F" "03_Images\"
        if /I "!EXT!"==".gif" move "%%F" "03_Images\"
        if /I "!EXT!"==".webp" move "%%F" "03_Images\"

        if /I "!EXT!"==".mp4" move "%%F" "04_Videos\"
        if /I "!EXT!"==".mov" move "%%F" "04_Videos\"
        if /I "!EXT!"==".avi" move "%%F" "04_Videos\"
        if /I "!EXT!"==".mkv" move "%%F" "04_Videos\"

        if /I "!EXT!"==".mp3" move "%%F" "05_Audio\"
        if /I "!EXT!"==".wav" move "%%F" "05_Audio\"
        if /I "!EXT!"==".m4a" move "%%F" "05_Audio\"

        if /I "!EXT!"==".xls" move "%%F" "06_Spreadsheets\"
        if /I "!EXT!"==".xlsx" move "%%F" "06_Spreadsheets\"
        if /I "!EXT!"==".csv" move "%%F" "06_Spreadsheets\"

        if /I "!EXT!"==".ppt" move "%%F" "07_Presentations\"
        if /I "!EXT!"==".pptx" move "%%F" "07_Presentations\"

        if /I "!EXT!"==".zip" move "%%F" "08_Archives\"
        if /I "!EXT!"==".rar" move "%%F" "08_Archives\"
        if /I "!EXT!"==".7z" move "%%F" "08_Archives\"

        if /I "!EXT!"==".exe" move "%%F" "09_Installers\"
        if /I "!EXT!"==".msi" move "%%F" "09_Installers\"
        if /I "!EXT!"==".apk" move "%%F" "09_Installers\"

        if /I "!EXT!"==".js" move "%%F" "10_Code\"
        if /I "!EXT!"==".html" move "%%F" "10_Code\"
        if /I "!EXT!"==".css" move "%%F" "10_Code\"
        if /I "!EXT!"==".py" move "%%F" "10_Code\"
        if /I "!EXT!"==".json" move "%%F" "10_Code\"
        if /I "!EXT!"==".bat" move "%%F" "10_Code\"
    )
)

echo.
echo Done organizing folder.
pause