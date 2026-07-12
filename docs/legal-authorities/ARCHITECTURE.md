# Architecture
Malaysia-first React/Vite → authenticated Express API → service layer → additive SQLite `legal_*` tables. Official text, licensed content, internal notes and AI output remain separate. Phase LA-02 stores reviewed metadata and links only.
```mermaid
flowchart LR
 UI[Legal Authorities UI]-->API[JWT/RBAC API]-->SVC[Services]-->DB[(legal_* tables)]
 REG[Reviewed registry]-->SVC
 EXT[External providers]-.deep links.->UI
```
```mermaid
flowchart TD
 A[Authority]-->P[Part]-->D[Division]-->S[Section]-->SS[Subsection]-->G[Paragraph]
```
