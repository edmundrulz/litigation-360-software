const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const source = process.argv[2];
if (!source || !fs.existsSync(source)) throw new Error("Usage: node scripts/generate-legal-glossary.cjs <Legal_Glossary.ini>");
const raw = fs.readFileSync(source, "utf8").replace(/^\uFEFF/, "");
const entries = raw.split(/\r?\n/).map((line, index) => ({ line, lineNumber: index + 1 }))
  .filter(({ line }) => line.trim() && !line.trim().startsWith(";") && !line.trim().startsWith("[") && line.includes("="))
  .map(({ line, lineNumber }) => { const separator = line.indexOf("="); return { term: line.slice(0, separator).trim(), definition: line.slice(separator + 1).trim(), sourceLine: lineNumber }; })
  .filter((entry) => entry.term && entry.definition);
const duplicateTerms = entries.map((entry) => entry.term.toLocaleLowerCase("en")).filter((term, index, all) => all.indexOf(term) !== index);
if (duplicateTerms.length) throw new Error(`Duplicate glossary keys: ${[...new Set(duplicateTerms)].join(", ")}`);
const checksum = crypto.createHash("sha256").update(raw, "utf8").digest("hex");
const target = path.resolve(__dirname, "../src/features/legal-reference/generated/legalGlossary.generated.js");
fs.mkdirSync(path.dirname(target), { recursive: true });
const payload = `// Generated from the user-supplied Legal_Glossary.ini. Do not edit manually.\nexport const glossarySource = ${JSON.stringify({ fileName: path.basename(source), format: "INI UTF-8", count: entries.length, sha256: checksum }, null, 2)};\n\nexport const importedGlossaryTerms = ${JSON.stringify(entries, null, 2)};\n`;
fs.writeFileSync(target, payload, "utf8");
console.log(`Generated ${entries.length} entries at ${target}`);
console.log(`SHA-256 ${checksum}`);
