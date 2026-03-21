# DONE-003: v2 Enhancements

**Refs:** TASK-003

## What was done
Implemented all three v2 enhancements: auto-generated nav (pre-generate approach), Obsidian wikilink support (sed + Lua filter), and client-side Pagefind search. Nav is now fully automatic — adding a new `.md` file to `content/en/` or `content/nl/` requires no manual index update.

## Files created
| Path | Purpose |
|------|---------|
| `.pandoc/wikilinks.lua` | Secondary Pandoc Lua filter for wikilinks |
| `search-en.md` | English search page with Pagefind UI |
| `search-nl.md` | Dutch search page with Pagefind UI |
| `_comms/03_DONE/DONE-003_20260321_v2-enhancements_v01.md` | This file |

## Files modified
| Path | Change |
|------|--------|
| `.github/workflows/deploy.yml` | Added Node.js setup, nav pre-generation, sed wikilink preprocessing, `--include-before-body`, `--lua-filter`, Pagefind build step |
| `index.md` | Removed hardcoded nav and page list (replaced by auto-nav) |
| `nl/index.md` | Same |
| `content/en/about.md` | Removed hardcoded `← Back` link |
| `content/en/note-1.md` | Same |
| `content/en/note-2.md` | Same |
| `content/nl/over-mij.md` | Removed hardcoded `← Terug` link |
| `content/nl/notitie-1.md` | Same |
| `content/nl/notitie-2.md` | Same |
| `_comms/02_TASK/TASK-003_20260321_v2-enhancements_v01.md` | Added decisions section, updated steps and file list |

## Decisions made
- **Auto nav:** Pre-generate HTML fragments in deploy.yml (not post-Pandoc HTML injection). Cleaner, stable, easy to debug.
- **Wikilinks:** sed preprocessing as primary (reliable, zero deps) + Lua filter as secondary safety net for edge cases. Both `[[target]]` and `[[target|label]]` supported.
- **Search:** Single bilingual Pagefind index for both EN and NL. Two separate search UI pages (`search-en.html`, `search-nl.html`). Node.js loaded via `actions/setup-node@v4`.
- Hardcoded back links and nav removed from all content and index Markdown files — nav is fully injected via `--include-before-body`.

## Issues / troubleshooting
None. Clean implementation in one pass.

## Next steps
- Add CSS rules for `.site-nav`, `.nav-back`, `.nav-lang`, `.nav-search`, `.auto-nav` to `style.css` (visual styling for the injected nav).
- Consider sorting the auto-nav list by frontmatter `date` field once notes have dates.
- Test wikilink resolution cross-language (NL note linking to EN note) — currently links resolve to `target.html` without a path prefix, which may need adjustment for cross-language links.

---
*Created: 2026-03-21 16:00:00 · v01*
