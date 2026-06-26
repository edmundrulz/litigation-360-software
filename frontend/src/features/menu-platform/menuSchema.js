export const MENU_ITEM_TYPES = Object.freeze({
  ACTION: "action",
  SUBMENU: "submenu",
  TOGGLE: "toggle",
  LINK: "link",
  SEPARATOR: "separator",
  PANEL: "panel",
});

export const MAX_MENU_DEPTH = 2;

/**
 * MenuItem shape:
 * {
 *   id: string,
 *   label: string,
 *   icon?: string,
 *   type: "action" | "submenu" | "toggle" | "link" | "separator" | "panel",
 *   shortcut?: string,
 *   enabled?: boolean,
 *   ariaLabel?: string,
 *   badge?: string,
 *   href?: string,
 *   children?: MenuItem[],
 *   keywords?: string[],
 *   favorite?: boolean,
 *   context?: ("sidebar" | "primary-action" | "global")[],
 *   featureFlag?: string
 * }
 */

export function isMenuItemEnabled(item, featureFlags = {}) {
  if (!item) return false;
  if (item.enabled === false) return false;
  if (item.featureFlag && featureFlags[item.featureFlag] !== true) return false;
  return true;
}

export function isItemVisibleInContext(item, context = "global") {
  if (!item?.context || item.context.length === 0) return true;
  return item.context.includes(context) || item.context.includes("global");
}

export function flattenMenuSections(sections, options = {}) {
  const {
    context = "global",
    featureFlags = {},
    includeDisabled = true,
    maxDepth = MAX_MENU_DEPTH,
  } = options;

  const output = [];

  function walk(items, section, parentTrail = [], depth = 0) {
    items.forEach((item) => {
      if (!isItemVisibleInContext(item, context)) return;
      if (!includeDisabled && !isMenuItemEnabled(item, featureFlags)) return;

      const trail = [...parentTrail, item.label];

      output.push({
        ...item,
        sectionId: section.id,
        sectionTitle: section.title,
        depth,
        trail,
        searchText: [
          item.id,
          item.label,
          item.shortcut,
          item.badge,
          section.title,
          ...(item.keywords || []),
          ...trail,
        ]
          .filter(Boolean)
          .join(" ")
          .toLowerCase(),
      });

      if (item.children?.length && depth < maxDepth) {
        walk(item.children, section, trail, depth + 1);
      }
    });
  }

  [...sections]
    .sort((a, b) => a.priority - b.priority)
    .forEach((section) => walk(section.items || [], section));

  return output;
}

export function filterMenuItems(sections, query, options = {}) {
  const normalized = String(query || "").trim().toLowerCase();
  const flat = flattenMenuSections(sections, options);

  if (!normalized) return [];

  return flat.filter((item) => item.searchText.includes(normalized));
}

export function collectFavoriteItems(sections, options = {}) {
  return flattenMenuSections(sections, options).filter((item) => item.favorite);
}

export function clampMenuDepth(items, depth = 0, maxDepth = MAX_MENU_DEPTH) {
  return items.map((item) => {
    if (!item.children?.length || depth >= maxDepth) {
      const { children, ...rest } = item;
      return rest;
    }

    return {
      ...item,
      children: clampMenuDepth(item.children, depth + 1, maxDepth),
    };
  });
}
