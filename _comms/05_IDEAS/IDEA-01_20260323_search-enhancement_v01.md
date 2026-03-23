# IDEA-01 — Enhanced Search: Maturity Filters & Category Browsing

## What this idea is about

The current search page uses Pagefind for full-text search. This idea extends it with:
1. **Maturity filter tabs** — filter notes by type: All | Seedling | Growing | Evergreen
2. **Category tile browser** — visual entry points by topic, above or alongside the search bar
3. **Richer search results** — show type badge, category, description, and author below each result title

Both features leverage the YAML frontmatter fields already defined in the note template (`type`, `category`, `description`, `author`).

---

## Feature 1 — Maturity Filter Tabs

### UI

```
[ All ]  [ 🌱 Seedling ]  [ 🌿 Growing ]  [ 🌳 Evergreen ]
```

Clicking a tab filters the note listing below to only show notes with that `type` value.

### Implementation options

**Option A: Client-side JS filter on the listing page**
- The homepage notes listing includes `data-type="seedling"` attributes on each `.note-card`
- A small JS snippet on the homepage (or a separate `/notes` listing page) hides cards that don't match the active filter
- No build-time changes required; filter is purely cosmetic
- Downside: requires a dedicated `/notes` listing page (separate from homepage) to avoid cluttering the homepage with filter UI

**Option B: Pre-built filter pages at build time**
- Deploy script generates `/en/notes-seedling.html`, `/en/notes-growing.html`, `/en/notes-evergreen.html`
- Each page contains only the relevant cards, pre-filtered
- Linked from the main notes page with standard `<a href>` tabs (no JS needed)
- Downside: more build output; does not update dynamically when filters are combined

**Recommended: Option A** on a dedicated `/en/notes.html` page, with a lightweight JS filter on the `data-type` attribute.

### Data requirements
Already available in frontmatter: `type: seedling | growing | evergreen`

---

## Feature 2 — Category Tile Browser

### UI

```
┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐
│    PKM    │  │    AI     │  │  Design   │  │ Strategy  │
│  (3 notes)│  │  (5 notes)│  │  (2 notes)│  │  (1 note) │
└───────────┘  └───────────┘  └───────────┘  └───────────┘
```

Each tile links to a pre-filtered view (or uses JS to filter the listing).

### Implementation options

**Option A: Build-time category pages**
- Deploy script iterates all unique `category` values
- Generates `/en/category-pkm.html`, `/en/category-ai.html`, etc.
- Each page contains only notes matching that category
- Category tiles on search/notes page link to these pages

**Option B: JS filter on the listing page**
- Cards have `data-category="PKM"` attributes
- Tile clicks filter the visible cards

**Recommended: Option A** for static reliability and SEO-friendliness.

### Curated category list (suggested starting set)

| Slug | Label |
|------|-------|
| `pkm` | PKM |
| `ai` | AI & Agents |
| `design` | Design |
| `strategy` | Strategy |
| `philosophy` | Philosophy |
| `technology` | Technology |
| `tools` | Tools |
| `writing` | Writing |
| `learning` | Learning |

These map to the `category` field in each note's YAML frontmatter. Keep the list short and stable; use `tags` for finer-grained classification.

---

## Feature 3 — Richer Pagefind Search Results

Pagefind renders its own result UI, but it supports custom data attributes for metadata display via `data-pagefind-meta`.

Add to each note page's HTML (in the `<article>` or `<body>`):
```html
<span data-pagefind-meta="type">seedling</span>
<span data-pagefind-meta="category">PKM</span>
<span data-pagefind-meta="author">Bram</span>
```

Then customise the `PagefindUI` initialisation to surface these fields in the result UI.

This can be injected by the deploy script as part of the per-note build step, using the same frontmatter values already extracted.

---

## Suggested build order

1. **Dedicated `/notes` listing page** — move the notes listing off the homepage (or duplicate it) to a page that can host the filter tabs without cluttering the index
2. **Client-side filter tabs** (Option A, Feature 1) — lightweight JS, no new build output
3. **Category tiles** (Option A, Feature 2) — build-time per-category pages + tile grid CSS
4. **Pagefind metadata** (Feature 3) — inject `data-pagefind-meta` attributes in the note build loop

---

## Notes & open questions

- Should maturity type labels be in English even on NL pages? (Seedling/Growing/Evergreen are garden metaphors that work cross-language; could also localise to Zaailing/Groeiend/Evergreen)
- Category list should be agreed on before building tiles — consider a `_data/categories.yml` file as a single source of truth
- Consider adding a `featured: true` flag in frontmatter to surface highlighted notes in a separate section on the homepage

---

*Created: 2026-03-23 00:00:00 · v01*
