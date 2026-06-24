# LESSONS LEARNED

## LL-001 - Do not mix CMD and PowerShell commands

Reason:

CMD and PowerShell use different syntax. Mixing them created malformed folders and command errors.

Lesson:

Litigation 360 operational scripts shall use PowerShell as the default standard.

## LL-002 - Always create audit reports after automation execution

Reason:

The owner must know what was created, changed, skipped, repaired or deleted.

Lesson:

Every major automation script must create a report.

## LL-003 - Empty files are not completion

Reason:

Folders and filenames alone do not create operational value.

Lesson:

Every governance file must contain usable instructions, rules, or records.

## LL-004 - Every phase must be verifiable

Reason:

A phase is only complete when its output can be checked.

Lesson:

Each phase must include inventory, audit or completion evidence.
