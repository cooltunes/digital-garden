---
Refs: PRD-01
---

# TASK-005 — Note Metadata & Restructure

## Goal
Align the build pipeline with the new `content/` subdirectory layout, introduce rich note frontmatter, display metadata on note pages and index listings, and create note templates for future use.

## Scope

**In scope:**
- Update `deploy.yml` for new folder structure (`content/en/en/`, `content/en/notes/`, `content/en/pages/`, and NL equivalents)
- Fix NL nav: `over-mij.html` → `about.html`
- Language switcher: link to translated note if `translation` field is set, else fall back to homepage
- Notes listing on homepage: cards with type, category, description, author, tags (sorted newest first)
- Per-note metadata display: category label above `<h1>`, byline below `<h1>`, footer with dates + version
- Note templates: `content/note-template-en.md` and `content/note-template-nl.md`
- Update existing placeholder notes with full frontmatter
- IDEA file: search enhancement with maturity filters and category tiles

**Out of scope:**
- Actual search filter implementation (future)
- Category tiles on search page (future, documented in IDEA file)

## Steps

- [x] Write TASK-005 file
- [ ] Create note templates (EN + NL)
- [ ] Update all 4 placeholder note files with full frontmatter
- [ ] Update EN and NL index pages (remove `{Please list…}` placeholder)
- [ ] Add CSS: `.notes-list`, `.note-card`, `.note-category-label`, `.note-byline`, `.note-footer`
- [ ] Rewrite `deploy.yml`:
  - New source paths for index, pages, notes
  - `build_notes_listing` function (sorted by `created`)
  - Inject notes listing via awk post-processing on index pages
  - Per-page nav with correct language switching
  - Per-note nav with translation-aware language link
  - Note page metadata injection (category label + byline) via awk
  - Note footer via `--include-after-body`
- [ ] Create `_comms/05_IDEAS/IDEA-01_20260323_search-enhancement_v01.md`
- [ ] Update `_comms/INDEX.md`
- [ ] Write DONE-005

## Files

**Created:**
- `content/note-template-en.md`
- `content/note-template-nl.md`
- `_comms/05_IDEAS/IDEA-01_20260323_search-enhancement_v01.md`
- `_comms/03_DONE/DONE-005_20260323_note-metadata-restructure_v01.md`

**Modified:**
- `.github/workflows/deploy.yml`
- `style.css`
- `content/en/en/index.md`
- `content/nl/nl/index.md`
- `content/en/notes/note-1.md`
- `content/en/notes/note-2.md`
- `content/nl/notes/notitie-1.md`
- `content/nl/notes/notitie-2.md`
- `_comms/INDEX.md`

## Open Questions
- None — scope is clear from user intent.

---
*Created: 2026-03-23 00:00:00 · v01*
