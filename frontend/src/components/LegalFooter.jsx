import "./LegalFooter.css";

export default function LegalFooter({ variant = "page" }) {
  const isPanel = variant === "panel";

  return (
    <section
      id={isPanel ? undefined : "legal-notice"}
      className={`legal-footer-section${isPanel ? " legal-footer-panel" : ""}`}
      aria-labelledby="legal-footer-title"
    >
      <div className="legal-footer-card">
        <h2 id="legal-footer-title" className="legal-footer-title">
          Disclaimer / Copyright Notice
        </h2>

        <p className="legal-footer-copyright">
          © 2026 Litigation LEOS 360. All Rights Reserved.
        </p>

        <div className="legal-footer-grid">
          <section>
            <h3>Ownership</h3>
            <p>
              All content, software, source code, workflows, layouts, databases,
              documents, templates, reports, graphics, branding, names, logos,
              and other materials made available through Litigation LEOS 360 are
              owned by, licensed to, or controlled by Litigation LEOS 360 and/or
              its lawful rights holders.
            </p>
          </section>

          <section>
            <h3>Permitted Use</h3>
            <p>
              Users may access and use this platform only for authorized,
              lawful, internal, operational, administrative, legal-technology,
              and workflow-support purposes.
            </p>
          </section>

          <section>
            <h3>Restrictions</h3>
            <p>
              No part of this platform, website, software, content, design,
              workflow, document, template, report, database, screenshot, or
              brand material may be copied, reproduced, modified, republished,
              distributed, scraped, reverse engineered, commercially exploited,
              used to train artificial intelligence systems, or incorporated
              into another product without prior written permission from
              Litigation LEOS 360.
            </p>
          </section>

          <section>
            <h3>Trademark Notice</h3>
            <p>
              “Litigation LEOS 360”, “LEOS 360”, associated logos, names,
              interface marks, product identifiers, and brand elements are
              trademarks, service marks, trade names, or proprietary identifiers
              of Litigation LEOS 360 and/or its lawful owners. Unauthorized use
              is strictly prohibited.
            </p>
          </section>

          <section>
            <h3>No Professional Advice</h3>
            <p>
              This platform is provided for general informational, operational,
              documentation, and legal-technology support purposes only. Nothing
              on this platform constitutes legal advice, legal representation,
              professional advice, or a guarantee of any legal, procedural,
              business, technical, or operational outcome.
            </p>
          </section>

          <section>
            <h3>Warranty Disclaimer</h3>
            <p>
              This platform and its content are provided on an “as is” and “as
              available” basis. To the fullest extent permitted by law,
              Litigation LEOS 360 disclaims all warranties, whether express,
              implied, statutory, or otherwise, including warranties of accuracy,
              completeness, reliability, availability, fitness for purpose,
              non-infringement, and uninterrupted operation.
            </p>
          </section>

          <section>
            <h3>Limitation of Liability</h3>
            <p>
              To the fullest extent permitted by law, Litigation LEOS 360 shall
              not be liable for any direct, indirect, incidental, consequential,
              special, commercial, reputational, technical, data-related, or
              operational loss arising from access to, use of, reliance on,
              misuse of, or inability to use this platform or any content,
              output, integration, or third-party service.
            </p>
          </section>

          <section>
            <h3>Third-Party Content</h3>
            <p>
              References, links, integrations, or materials from third parties
              are provided for convenience only and do not imply endorsement,
              control, or responsibility by Litigation LEOS 360. Third-party
              services remain subject to their own terms and policies.
            </p>
          </section>

          <section>
            <h3>Governing Law</h3>
            <p>
              This notice is governed by the laws of Malaysia unless another
              written agreement applies. Litigation LEOS 360 reserves all rights
              to enforce its intellectual property, contractual, proprietary,
              and related rights in Malaysia and any applicable international
              jurisdiction.
            </p>
          </section>
        </div>
      </div>
    </section>
  );
}
