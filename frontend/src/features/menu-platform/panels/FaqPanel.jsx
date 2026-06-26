import { useMemo, useState } from "react";

const FAQ_ITEMS = [
  {
    id: "faq-navigation",
    category: "Navigation",
    question: "How do I quickly find an option?",
    answer:
      "Use the menu search box at the top. It searches labels, shortcuts, section names, and keywords.",
  },
  {
    id: "faq-favorites",
    category: "Navigation",
    question: "Can I pin common actions?",
    answer:
      "Yes. Favorite items appear in the pinned row near the top of the menu for faster access.",
  },
  {
    id: "faq-support",
    category: "Support",
    question: "What should I include in a bug report?",
    answer:
      "Include what you clicked, what you expected, what happened, screenshots if possible, and any error text or logs.",
  },
  {
    id: "faq-accessibility",
    category: "Accessibility",
    question: "Does the menu support keyboard navigation?",
    answer:
      "Yes. Use Arrow Up and Arrow Down to move, Enter or Space to select, Escape to close, and Tab to exit.",
  },
  {
    id: "faq-mobile",
    category: "Mobile",
    question: "How does the menu behave on mobile?",
    answer:
      "On small screens the dropdown becomes a full-height mobile sheet so the options and support form remain usable.",
  },
];

export function FaqPanel() {
  const [query, setQuery] = useState("");
  const [openId, setOpenId] = useState(FAQ_ITEMS[0].id);

  const filteredItems = useMemo(() => {
    const normalized = query.trim().toLowerCase();
    if (!normalized) return FAQ_ITEMS;

    return FAQ_ITEMS.filter((item) =>
      [item.category, item.question, item.answer]
        .join(" ")
        .toLowerCase()
        .includes(normalized)
    );
  }, [query]);

  return (
    <section className="mp-panel" aria-labelledby="mp-panel-faq-title">
      <div className="mp-panel-header">
        <div>
          <h2 id="mp-panel-faq-title">FAQ</h2>
          <p>Search common questions, help topics, and quick suggestions.</p>
        </div>
      </div>

      <label className="mp-field">
        <span>Search FAQ</span>
        <input
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="Search help topics..."
        />
      </label>

      <div className="mp-faq-list">
        {filteredItems.map((item) => {
          const isOpen = openId === item.id;

          return (
            <article className="mp-faq-item" key={item.id}>
              <button
                type="button"
                className="mp-faq-question"
                aria-expanded={isOpen}
                onClick={() => setOpenId(isOpen ? "" : item.id)}
              >
                <span>
                  <small>{item.category}</small>
                  {item.question}
                </span>
                <span aria-hidden="true">{isOpen ? "−" : "+"}</span>
              </button>

              {isOpen ? <p className="mp-faq-answer">{item.answer}</p> : null}
            </article>
          );
        })}
      </div>

      {filteredItems.length === 0 ? (
        <p className="mp-empty">No FAQ result found. Submit a request instead.</p>
      ) : null}
    </section>
  );
}
