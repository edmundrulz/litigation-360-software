const commonEmailDomains = [
  "gmail.com",
  "googlemail.com",
  "outlook.com",
  "hotmail.com",
  "live.com",
  "msn.com",
  "yahoo.com",
  "ymail.com",
  "icloud.com",
  "me.com",
  "mac.com",
  "proton.me",
  "protonmail.com",
  "zoho.com",
  "aol.com",
  "mail.com",
  "gmx.com",
  "gmx.net",
  "fastmail.com",
  "tutanota.com",
];

const malaysiaSingaporeDomains = [
  "company.com.my",
  "company.my",
  "company.net.my",
  "company.org.my",
  "company.com.sg",
  "company.sg",
  "company.net.sg",
  "company.org.sg",
  "lawfirm.com.my",
  "lawfirm.my",
  "lawfirm.com.sg",
];

const commonTlds = [
  ".com",
  ".net",
  ".org",
  ".info",
  ".biz",
  ".name",
  ".pro",
];

const techTlds = [
  ".app",
  ".dev",
  ".io",
  ".ai",
  ".cloud",
  ".digital",
  ".tech",
  ".software",
  ".systems",
  ".tools",
  ".solutions",
  ".network",
];

const businessTlds = [
  ".email",
  ".online",
  ".site",
  ".store",
  ".shop",
  ".agency",
  ".company",
  ".group",
  ".services",
  ".support",
];

const legalTlds = [
  ".legal",
  ".law",
  ".lawyer",
  ".attorney",
];

const allEmailSuggestions = Array.from(
  new Set([
    ...commonEmailDomains,
    ...malaysiaSingaporeDomains,
    ...commonTlds,
    ...techTlds,
    ...businessTlds,
    ...legalTlds,
  ])
);

export {
  commonEmailDomains,
  malaysiaSingaporeDomains,
  commonTlds,
  techTlds,
  businessTlds,
  legalTlds,
  allEmailSuggestions,
};
