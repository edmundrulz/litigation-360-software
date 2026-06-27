import React, { useEffect, useMemo, useRef, useState } from "react";
import { allEmailSuggestions } from "../data/emailSuggestions";
import { getEmailWarnings } from "../utils/emailValidation";

function EmailAutocompleteInput({
  value = "",
  onChange,
  label = "Email",
  placeholder = "name@example.com",
  required = false,
  disabled = false,
  helperText = "",
  name = "email",
  id = "email",
}) {
  const wrapperRef = useRef(null);
  const [isOpen, setIsOpen] = useState(false);
  const [highlightedIndex, setHighlightedIndex] = useState(0);

  const normalizedValue = value || "";
  const warnings = getEmailWarnings(normalizedValue);

  const usernamePart = normalizedValue.includes("@")
    ? normalizedValue.split("@")[0]
    : normalizedValue;

  const domainPart = normalizedValue.includes("@")
    ? normalizedValue.split("@").slice(1).join("@").toLowerCase()
    : "";

  const suggestions = useMemo(() => {
    if (!normalizedValue.includes("@")) return [];

    return allEmailSuggestions
      .filter((suggestion) => {
        const normalizedSuggestion = suggestion.replace(/^\./, "").toLowerCase();

        if (!domainPart) return !suggestion.startsWith(".");

        return (
          normalizedSuggestion.startsWith(domainPart) ||
          suggestion.toLowerCase().startsWith(domainPart)
        );
      })
      .slice(0, 10);
  }, [domainPart, normalizedValue]);

  useEffect(() => {
    function handleClickOutside(event) {
      if (wrapperRef.current && !wrapperRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside);

    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  useEffect(() => {
    setHighlightedIndex(0);
  }, [domainPart]);

  function emitChange(nextValue) {
    if (typeof onChange === "function") {
      onChange(nextValue);
    }
  }

  function applySuggestion(suggestion) {
    let nextValue = "";

    if (suggestion.startsWith(".")) {
      const baseDomain = domainPart.split(".")[0] || "company";
      nextValue = `${usernamePart}@${baseDomain}${suggestion}`;
    } else {
      nextValue = `${usernamePart}@${suggestion}`;
    }

    emitChange(nextValue);
    setIsOpen(false);
  }

  function handleInputChange(event) {
    emitChange(event.target.value);
    setIsOpen(event.target.value.includes("@"));
  }

  function handleFocus() {
    if (normalizedValue.includes("@")) {
      setIsOpen(true);
    }
  }

  function handleKeyDown(event) {
    if (!isOpen || suggestions.length === 0) {
      if (event.key === "Escape") {
        setIsOpen(false);
      }

      return;
    }

    if (event.key === "ArrowDown") {
      event.preventDefault();
      setHighlightedIndex((currentIndex) =>
        currentIndex >= suggestions.length - 1 ? 0 : currentIndex + 1
      );
    }

    if (event.key === "ArrowUp") {
      event.preventDefault();
      setHighlightedIndex((currentIndex) =>
        currentIndex <= 0 ? suggestions.length - 1 : currentIndex - 1
      );
    }

    if (event.key === "Enter") {
      event.preventDefault();
      applySuggestion(suggestions[highlightedIndex]);
    }

    if (event.key === "Escape") {
      setIsOpen(false);
    }
  }

  return (
    <div className="email-autocomplete-input" ref={wrapperRef}>
      {label ? (
        <label className="email-autocomplete-label" htmlFor={id}>
          {label}
          {required ? <span aria-hidden="true"> *</span> : null}
        </label>
      ) : null}

      <input
        id={id}
        name={name}
        type="email"
        value={normalizedValue}
        placeholder={placeholder}
        required={required}
        disabled={disabled}
        autoComplete="email"
        onChange={handleInputChange}
        onFocus={handleFocus}
        onKeyDown={handleKeyDown}
        aria-autocomplete="list"
        aria-expanded={isOpen}
      />

      {isOpen && suggestions.length > 0 ? (
        <ul className="email-autocomplete-suggestions" role="listbox">
          {suggestions.map((suggestion, index) => (
            <li key={suggestion}>
              <button
                type="button"
                className={
                  index === highlightedIndex
                    ? "email-autocomplete-suggestion is-highlighted"
                    : "email-autocomplete-suggestion"
                }
                onMouseDown={(event) => {
                  event.preventDefault();
                  applySuggestion(suggestion);
                }}
              >
                {suggestion.startsWith(".")
                  ? `${usernamePart}@${domainPart.split(".")[0] || "company"}${suggestion}`
                  : `${usernamePart}@${suggestion}`}
              </button>
            </li>
          ))}
        </ul>
      ) : null}

      {helperText ? (
        <small className="email-autocomplete-helper">{helperText}</small>
      ) : null}

      {warnings.length > 0 ? (
        <small className="email-autocomplete-warning">
          {warnings[0]}
        </small>
      ) : null}
    </div>
  );
}

export default EmailAutocompleteInput;
