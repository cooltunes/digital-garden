---
Refs: TASK-005
---

# DONE-005 — Note Metadata & Restructure

## What was done

Updated the build pipeline to match the new `content/` subdirectory layout, introduced rich note frontmatter, added metadata display on note pages and listing cards on the homepage, and created note templates for future use.

## Files created
- `content/note-template-en.md` — EN note template with full YAML frontmatter
- `content/note-template-nl.md` — NL note template with full YAML frontmatter
- `_comms/05_IDEAS/IDEA-01_20260323_search-enhancement_v01.md` — idea file for maturity filters and category tiles

## Files modified
- `.github/workflows/deploy.yml` — full rewrite for new folder structure + metadata features
- `style.css` — added `.notes-list`, `.note-card`, `.note-type`, `.note-category-label`, `.note-byline`, `.note-footer` styles
- `content/en/en/index.md` — removed `{Please list…}` placeholder
- `content/nl/nl/index.md` — removed `{Please list…}` placeholder
- `content/en/notes/note-1.md` — updated with full frontmatter
- `content/en/notes/note-2.md` — updated with full frontmatter
- `content/nl/notes/notitie-1.md` — updated with full frontmatter
- `content/nl/notes/notitie-2.md` — updated with full frontmatter
- `_comms/INDEX.md` — added TASK-005 and IDEA-01

## Decisions made

**Notes listing injection via awk post-processing:** Pandoc doesn't support dynamic mid-document injection. The notes listing HTML fragment is generated first, then injected into the built index HTML after the `<h2 id="notes">` heading using awk. This keeps the pipeline bash-native with no extra dependencies.

**Note metadata display via awk post-processing:** Category label (above `<h1>`) and byline (below `<h1>`) are injected into the Pandoc-generated HTML by matching `/<h1[> ]/`. Footer is injected via Pandoc's `--include-after-body`.

**Per-note nav:** Each note gets its own nav bar, generated inside the build loop. The NL language link uses the `translation` field (slug of the equivalent NL note); if absent, falls back to the NL homepage.

**NL nav fix:** Both EN and NL "about" pages now use `about.html` (the file was renamed from `over-mij.md`). The NL nav still shows "OVER MIJ" as the link label.

**Frontmatter fields added:** `description`, `author`, `written_by`, `status`, `type`, `category`, `tags`, `language`, `translation`, `source`, `related`, `created`, `modified`, `version`.

## Issues / troubleshooting
None — all features are additive and backward-compatible. Placeholder notes with empty `category`/`tags` fields gracefully skip those elements in the listing.

## Next steps
- IDEA-01: implement maturity filter tabs on a dedicated `/notes` listing page
- IDEA-01: implement category tile browser (pre-built per-category pages)
- Add `data-pagefind-meta` attributes in the note build loop for richer search results
- Consider a `_data/categories.yml` as single source of truth for the curated category list

---
*Created: 2026-03-23 00:00:00 · v01*
