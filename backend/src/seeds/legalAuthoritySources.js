const sources = [
  ["AGC_LOM", "Federal Legislation Portal (Laws of Malaysia)", "Attorney General's Chambers Malaysia", "https://lom.agc.gov.my/", "official_legislation", "official_primary", "public", 0, "public_official", "metadata_only"],
  ["JUDICIARY_MAIN", "Malaysian Judiciary", "Office of the Chief Registrar, Federal Court of Malaysia", "https://www.kehakiman.gov.my/", "official_judiciary", "official_primary", "public", 0, "public_official", "metadata_only"],
  ["EJUDGMENT", "Malaysia eJudgment", "Malaysian Judiciary", "https://ejudgment.kehakiman.gov.my/EJudgmentWeb/SearchPage.aspx", "official_case_law", "official_primary", "public", 0, "public_official", "metadata_only"],
  ["ECOURT", "e-Court Services", "Malaysian Judiciary", "https://ecourtservices.kehakiman.gov.my/", "official_judiciary", "official_service", "authenticated_public", 1, "restricted_service", "external_link"],
  ["PARLIAMENT_MY", "Parliament of Malaysia", "Parliament of Malaysia", "https://www.parlimen.gov.my/", "official_legislative_history", "official_legislative_history", "public", 0, "public_official", "metadata_only"],
  ["MALAYSIAN_BAR", "Malaysian Bar", "Bar Council Malaysia", "https://www.malaysianbar.org.my/", "professional_secondary", "professional_secondary", "authenticated_public", 0, "mixed_public_member", "metadata_only"],
  ["CLJ", "CLJLaw", "CLJ Legal Network", "https://www.cljlaw.com/", "licensed_case_law", "licensed_secondary", "subscription", 1, "commercial_subscription", "external_link"],
  ["LEXIS_MY", "Lexis+ Malaysia / LexisNexis Malaysia", "LexisNexis", "https://www.lexisnexis.com/en-my", "licensed_case_law", "licensed_secondary", "subscription", 1, "commercial_subscription", "external_link"],
  ["LAWNET_MY", "LawNet Malaysia", "LawNet Malaysia", "https://www.lawnet.com.my/", "licensed_commentary", "gazette_and_secondary", "subscription", 1, "commercial_subscription", "external_link"],
  ["E_FEDERAL_GAZETTE", "Federal Gazette access", "Attorney General's Chambers Malaysia", "https://lom.agc.gov.my/", "official_gazette", "official_primary", "public", 0, "public_official", "metadata_only"],
];

module.exports = sources.map(([source_id, source_name, provider_name, base_url, source_category, authority_rank, access_type, authentication_required, licence_type, integration_mode]) => ({
  source_id, source_name, provider_name, base_url, jurisdiction: "Malaysia", source_category,
  authority_rank, access_type, authentication_required, licence_type, integration_mode,
  api_available: 0, bulk_download_available: 0, scraping_status: "disabled",
  robots_review_status: "not_reviewed", terms_review_status: "not_reviewed",
  full_text_storage_allowed: 0, metadata_storage_allowed: 1, deep_linking_allowed: 1,
  verification_status: "pending_review", enabled: 1,
  notes: "Starter metadata only. Verify current terms, status and permitted integration before use."
}));
