# Document Intake Protocol

Drop new documents into:
data\document-intake\01_INBOX_NEW_DOCUMENTS

System process:
1. Detect new document
2. Extract metadata
3. Classify document type
4. Match client
5. Match matter
6. Check duplicate risk
7. Generate safe filename
8. Send to human review if confidence is low
9. File into correct matter folder only after approval

No document should be permanently moved without audit logging.
