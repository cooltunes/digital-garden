# TASK-003: v2 Enhancements

**Refs:** PRD-01, RETRO-01

## Goal
Extend the digital garden with three quality-of-life improvements: automatic navigation, wikilink support, and client-side search.

## Scope

### Feature 1 — Auto nav menu
Generate a navigation list automatically from all `.md` files in `content/en/` (and `content/nl/`) during the build step. Removes the manual step of adding a link to `index.md` every time a new note is published.

**Approach:** Bash script in `deploy.yml` iterates over `content/en/*.md`, extracts the `title` from each file's frontmatter, and injects an `<ul>` nav block into the built `index.html` — or pre-generates a `_nav.md` include before Pandoc runs.

**Open questions:**
- Inject into HTML post-Pandoc (fragile) or generate a Markdown include pre-Pandoc (cleaner)?
- Sort order: alphabetical, by date in filename, or by frontmatter `date` field?

---

### Feature 2 — Wikilinks
Allow Obsidian-style `[[page-name]]` syntax in `.md` files. Pandoc does not support this natively.

**Approach:** A Pandoc Lua filter that rewrites `[[page-name]]` → `[page-name](page-name.html)` before conversion. Filter lives at `.pandoc/wikilinks.lua` and is passed via `--lua-filter` in the workflow.

**Open questions:**
- Handle display aliases `[[page|Label]]`?
- Cross-language links (NL note linking to EN note)?

---

### Feature 3 — Search (Pagefind)
Add client-side full-text search using [Pagefind](https://pagefind.app/). No server required — Pagefind indexes the built HTML and ships a small JS bundle.

**Approach:** Add a `pagefind` build step after Pandoc in `deploy.yml`. Add a `search.html` page with the Pagefind UI. Link from both homepages.

**Open questions:**
- Bilingual index: single index or separate EN/NL indexes?
- Pagefind requires Node.js in the Actions runner — acceptable given it's cloud-only?

---

## Decisions (from planning session 2026-03-21)

### Feature 1 — Nav approach
**Decision: Pre-generate Markdown include (not post-Pandoc HTML injection).**
Bash loop extracts `title` from frontmatter, writes `_nav_en_index.html` / `_nav_nl_index.html` fragments with the auto page list. Content pages get `_nav_en_page.html` / `_nav_nl_page.html` (Back + language switch + search icon). All injected via `--include-before-body`.

**Nav structure on every page:** `← Back  EN · NL · 🔍`

**Sort order:** alphabetical by title (glob order, filename-based).

### Feature 2 — Wikilinks
**Decision: sed preprocessing as primary + Lua filter as secondary safety net.**
Sed converts `[[target|label]]` → `[label](target.html)` and `[[target]]` → `[target](target.html)` before Pandoc. Lua filter handles edge cases where Pandoc's reference-link parser produces a `Link` with empty href.
**Alias support** (`[[page|Label]]`): yes, handled by sed.

### Feature 3 — Search
**Decision: single bilingual Pagefind index.** One `npx pagefind --site _site` step indexes all EN + NL content. Two separate search pages: `search-en.html` and `search-nl.html` (same index, different UI language).
Node.js via `actions/setup-node@v4` in the Actions runner — acceptable, cloud-only.

---

## Steps
- [ ] Feature 1: Auto nav menu
  - [ ] Pre-generate `_nav_en_index.html`, `_nav_nl_index.html`, `_nav_en_page.html`, `_nav_nl_page.html` in deploy.yml
  - [ ] Pass `--include-before-body` to all Pandoc calls
  - [ ] Remove hardcoded nav/list from `index.md`, `nl/index.md`
  - [ ] Remove hardcoded back links from all 6 content `.md` files
- [ ] Feature 2: Wikilinks
  - [ ] Write `.pandoc/wikilinks.lua` (secondary Lua filter)
  - [ ] Add sed preprocessing function in deploy.yml
  - [ ] Add `--lua-filter .pandoc/wikilinks.lua` to all Pandoc calls
- [ ] Feature 3: Search
  - [ ] Add `actions/setup-node@v4` to deploy.yml
  - [ ] Add `npx pagefind --site _site` build step
  - [ ] Create `search-en.md` and `search-nl.md`

## Files to create / modify
| Action | Path |
|--------|------|
| Modify | `.github/workflows/deploy.yml` |
| Create | `.pandoc/wikilinks.lua` |
| Create | `search-en.md` |
| Create | `search-nl.md` |
| Modify | `index.md` |
| Modify | `nl/index.md` |
| Modify | `content/en/about.md` |
| Modify | `content/en/note-1.md` |
| Modify | `content/en/note-2.md` |
| Modify | `content/nl/over-mij.md` |
| Modify | `content/nl/notitie-1.md` |
| Modify | `content/nl/notitie-2.md` |

---
*Created: 2026-03-21 15:15:00 · v01*
