@echo off
setlocal enabledelayedexpansion

echo =====================================================
echo LITIGATION 360 - SAFE AI PROMPTS + POLICY INSTALLER
echo Additive-only. No deletion. No replacement by default.
echo =====================================================

cd /d "%~dp0\.."

set BACKUP_DIR=backup\pre-ai-prompts-%date:~-4%%date:~4,2%%date:~7,2%-%time:~0,2%%time:~3,2%%time:~6,2%
set BACKUP_DIR=%BACKUP_DIR: =0%

echo.
echo Creating backup folder:
echo %BACKUP_DIR%
mkdir "%BACKUP_DIR%" 2>nul

echo.
echo Creating required folders...
mkdir "backend\src\prompts" 2>nul
mkdir "backend\src\config" 2>nul
mkdir "backend\scripts" 2>nul
mkdir "docs" 2>nul

echo.
echo Backing up existing files if present...

for %%F in (
"backend\src\prompts\legalAuditor.prompts.js"
"backend\src\prompts\opposingCounsel.prompts.js"
"backend\src\prompts\scriptReviewer.prompts.js"
"backend\src\prompts\studyCoach.prompts.js"
"backend\src\config\malaysiaPublicHolidays.json"
"backend\src\config\deadlineRules.config.js"
"docs\SAFE_CHANGE_POLICY.md"
"docs\AI_PROMPT_LIBRARY.md"
) do (
    if exist %%F (
        echo Backing up %%F
        copy %%F "%BACKUP_DIR%\" >nul
    )
)

echo.
echo Writing files only if they do not already exist...

if not exist "backend\src\prompts\legalAuditor.prompts.js" (
powershell -NoProfile -Command "@'
const legalAuditorPrompts = {
  rulesOfCourtReview: `
Review this draft against the applicable Rules of Court and highlight any potential procedural inconsistencies.

Check for:
1. Filing defects
2. Wrong procedure
3. Missing supporting documents
4. Deadline risks
5. Incorrect prayer or relief
6. Weak evidential foundation
7. Procedural non-compliance
8. Formatting or drafting concerns

Return:
- Issue detected
- Severity
- Reason
- Suggested correction
- Risk if ignored
`,

  caseTheoryReview: `
Summarize these case facts and suggest 3 potential legal theories that align with previous successful firm outcomes.

For each theory provide:
1. Legal theory
2. Supporting facts
3. Weaknesses
4. Evidence required
5. Probability of success
6. Strategic recommendation
`
};

module.exports = legalAuditorPrompts;
'@ | Set-Content -Encoding UTF8 'backend\src\prompts\legalAuditor.prompts.js'"
) else (
echo SKIPPED existing legalAuditor.prompts.js
)

if not exist "backend\src\prompts\opposingCounsel.prompts.js" (
powershell -NoProfile -Command "@'
const opposingCounselPrompts = {
  redTeamReview: `
Act as opposing counsel. Find weaknesses, gaps, contradictions, procedural defects, evidential weaknesses, and strategic vulnerabilities in this argument before filing.

Return:
1. Weakness
2. How opposing counsel may exploit it
3. Severity
4. Countermeasure
5. Suggested amendment
`,

  adversarialStrategy: `
Propose three specific counter-arguments that a competent opposing counsel would use to neutralize these claims.

For each counter-argument provide:
1. Argument
2. Legal basis
3. Factual basis
4. Expected impact
5. Recommended response
`,

  legalAuditorSimulation: `
You are the Legal Auditor Red Team for Litigation 360.

Your role is to challenge litigation strategy, detect weak arguments, expose procedural risks, identify missing evidence, and simulate competent opposing counsel.
`
};

module.exports = opposingCounselPrompts;
'@ | Set-Content -Encoding UTF8 'backend\src\prompts\opposingCounsel.prompts.js'"
) else (
echo SKIPPED existing opposingCounsel.prompts.js
)

if not exist "backend\src\prompts\scriptReviewer.prompts.js" (
powershell -NoProfile -Command "@'
const scriptReviewerPrompts = {
  fullSafetyReview: `
I want you to act as a senior software architect, cybersecurity reviewer, DevOps engineer, QA tester, and systems reliability engineer.

Please thoroughly review, diagnose, stress-test, and harden the following command/code/script logic:

[PASTE COMMAND / CODE / SCRIPT HERE]

Your review must cover:
1. Code logic correctness
2. Bugs, crashes, dead ends, and failure points
3. Security risks, vulnerabilities, injection risks, permission risks, and unsafe behavior
4. Data safety risks including deletion, overwrite, duplication, corruption, or loss
5. Integration risks involving frontend, backend, database, APIs, services, ports, dependencies, OS, and environment variables
6. Redundant, obsolete, weak, inefficient, or unnecessary logic
7. Backup, rollback, recovery, fail-safe, kill-switch, logging, audit trail, and error handling
8. Stability, reliability, maintainability, scalability, and performance
9. Edge cases, rare failures, abnormal inputs, and unexpected output
10. App-readiness, production-readiness, monitoring, debugging, and operational safety

Provide:
- Full risk assessment
- Detected weaknesses
- Severity rating: Critical / High / Medium / Low
- Exact fixes
- Safer corrected code where needed
- Safeguards and fail-safes
- Pre-run checklist
- Post-run verification checklist
- Rollback/recovery plan
- Final verdict: Safe to run / Unsafe to run / Safe only after fixes

Do not assume anything is safe.
`,

  completenessReview: `
Verify thoroughly and confirm that the provided script is complete and contains every element currently in use.

Check for:
1. Completeness and integrity
2. Missing sections
3. Removed or substituted logic
4. Whether it matches the deployed working version
5. Whether additions are append-only

Final version must contain all existing code plus new additions.
Do not replace or remove current functionality.
`
};

module.exports = scriptReviewerPrompts;
'@ | Set-Content -Encoding UTF8 'backend\src\prompts\scriptReviewer.prompts.js'"
) else (
echo SKIPPED existing scriptReviewer.prompts.js
)

if not exist "backend\src\prompts\studyCoach.prompts.js" (
powershell -NoProfile -Command "@'
const studyCoachPrompts = {
  narrativeUnderstanding: `
Provide comprehensive study strategies, practical notes, actionable pointers, and detailed guidance for improving ability to:

1. Understand narrative questions and passages
2. Recall details, quotes, plot points, characters, and sequence
3. Revise efficiently and detect knowledge gaps
4. Decode symbolism, metaphors, foreshadowing, subtext, and hidden meaning
5. Explain answers clearly with structure, evidence, and themes

Include:
- Action steps
- Common mistakes
- Examples
- SQ3R
- Close reading
- Annotation
- Test anxiety management
`
};

module.exports = studyCoachPrompts;
'@ | Set-Content -Encoding UTF8 'backend\src\prompts\studyCoach.prompts.js'"
) else (
echo SKIPPED existing studyCoach.prompts.js
)

if not exist "backend\src\config\malaysiaPublicHolidays.json" (
powershell -NoProfile -Command "@'
{
  ""country"": ""Malaysia"",
  ""purpose"": ""Deadline calculator non-working day prevention"",
  ""note"": ""Populate yearly federal and state holidays before production use."",
  ""federalHolidays"": [],
  ""stateHolidays"": {
    ""Selangor"": [],
    ""Kuala Lumpur"": [],
    ""Putrajaya"": [],
    ""Johor"": [],
    ""Penang"": [],
    ""Perak"": [],
    ""Negeri Sembilan"": [],
    ""Melaka"": [],
    ""Pahang"": [],
    ""Terengganu"": [],
    ""Kelantan"": [],
    ""Kedah"": [],
    ""Perlis"": [],
    ""Sabah"": [],
    ""Sarawak"": [],
    ""Labuan"": []
  }
}
'@ | Set-Content -Encoding UTF8 'backend\src\config\malaysiaPublicHolidays.json'"
) else (
echo SKIPPED existing malaysiaPublicHolidays.json
)

if not exist "backend\src\config\deadlineRules.config.js" (
powershell -NoProfile -Command "@'
const malaysiaPublicHolidays = require('./malaysiaPublicHolidays.json');

const deadlineRulesConfig = {
  jurisdiction: 'Malaysia',
  defaultState: 'Selangor',
  excludeWeekends: true,
  excludePublicHolidays: true,
  publicHolidaySource: malaysiaPublicHolidays,
  productionWarning: 'Holiday list must be verified yearly before production use.'
};

module.exports = deadlineRulesConfig;
'@ | Set-Content -Encoding UTF8 'backend\src\config\deadlineRules.config.js'"
) else (
echo SKIPPED existing deadlineRules.config.js
)

if not exist "docs\SAFE_CHANGE_POLICY.md" (
powershell -NoProfile -Command "@'
# Litigation 360 Safe Change Policy

## Core Rule

No deletion, replacement, substitution, or removal of existing code is allowed without explicit written approval.

## Mandatory Procedure

1. Backup before change
2. Inspect existing file
3. Confirm current functionality
4. Propose exact addition
5. Obtain approval
6. Apply minimal additive patch
7. Test
8. Verify
9. Document result

## Default Allowed Change Type

Append-only or additive-only.

## Restricted Actions

- No deleting lines
- No commenting out existing logic
- No replacing working code
- No restructuring without approval
- No changing business logic without approval
- No modifying production files without backup

## Verification Requirement

Every change must have:
- Pre-run checklist
- Post-run verification
- Rollback plan
- Pass/fail result
'@ | Set-Content -Encoding UTF8 'docs\SAFE_CHANGE_POLICY.md'"
) else (
echo SKIPPED existing SAFE_CHANGE_POLICY.md
)

if not exist "docs\AI_PROMPT_LIBRARY.md" (
powershell -NoProfile -Command "@'
# Litigation 360 AI Prompt Library

## Legal Auditor

- Review draft against Rules of Court
- Highlight procedural inconsistencies
- Identify filing risks
- Suggest corrections

## Case Theory Assistant

- Summarize case facts
- Suggest legal theories
- Match arguments to previous successful outcomes

## Opposing Counsel Simulator

- Act as opposing counsel
- Find weaknesses
- Identify gaps
- Propose counter-arguments

## Red Team Legal Auditor

- Challenge litigation strategy
- Detect evidential weaknesses
- Identify procedural defects
- Prepare countermeasure recommendations

## Script Safety Reviewer

- Review command/code/script safety
- Detect crash risks
- Detect deletion/overwrite risk
- Provide rollback plan
- Provide final safety verdict

## Study Coach

- Improve understanding
- Improve recall
- Improve revision
- Decode complex questions
- Explain answers clearly
'@ | Set-Content -Encoding UTF8 'docs\AI_PROMPT_LIBRARY.md'"
) else (
echo SKIPPED existing AI_PROMPT_LIBRARY.md
)

echo.
echo =====================================================
echo VERIFYING FILES
echo =====================================================

for %%F in (
"backend\src\prompts\legalAuditor.prompts.js"
"backend\src\prompts\opposingCounsel.prompts.js"
"backend\src\prompts\scriptReviewer.prompts.js"
"backend\src\prompts\studyCoach.prompts.js"
"backend\src\config\malaysiaPublicHolidays.json"
"backend\src\config\deadlineRules.config.js"
"docs\SAFE_CHANGE_POLICY.md"
"docs\AI_PROMPT_LIBRARY.md"
) do (
    if exist %%F (
        echo PASS %%F
    ) else (
        echo FAIL %%F
    )
)

echo.
echo =====================================================
echo INSTALLATION COMPLETE
echo No files deleted.
echo Existing files skipped.
echo Backups saved to: %BACKUP_DIR%
echo =====================================================

pause
endlocal