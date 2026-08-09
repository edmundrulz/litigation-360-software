const groups = {
  constitutional: ["constitution", "constitutional_article", "constitutional_schedule", "constitutional_amendment"],
  legislation: ["act", "amending_act", "code", "ordinance", "state_enactment", "subsidiary_legislation", "regulation", "rule", "order", "notification", "declaration", "direction", "by_law", "gazette"],
  hierarchy: ["part", "division", "chapter", "section", "subsection", "paragraph", "subparagraph", "proviso", "schedule", "form", "appendix"],
  case_law: ["judgment", "reported_case", "unreported_case", "tribunal_award", "industrial_court_award", "judicial_precedent"],
  practice: ["practice_direction", "practice_note", "court_rule", "court_form", "court_notice", "drafting_precedent", "template", "workflow"],
  concepts: ["cause_of_action", "offence", "defence", "remedy", "procedure", "evidence_rule", "sentencing_principle", "doctrine", "principle", "legal_test", "maxim", "legal_term"],
  institutions: ["institution", "court", "tribunal", "regulator", "person_role"]
};

module.exports = Object.entries(groups).flatMap(([category_group, types]) => types.map((authority_type, index) => ({
  authority_type,
  display_name: authority_type.split("_").map((word) => word[0].toUpperCase() + word.slice(1)).join(" "),
  description: `Configurable ${authority_type.replaceAll("_", " ")} authority classification.`,
  category_group,
  enabled: 1,
  display_order: index + 1
})));
