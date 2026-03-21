# RETRO-01: Digital Garden — Launch

**Refs:** PRD-01, TASK-001, TASK-002

---

## What we built

A fully static, bilingual (EN/NL) digital garden: Obsidian `.md` files → Pandoc → GitHub Actions → GitHub Pages. Zero local toolchain beyond Git. One `git push` publishes.

---

## What went well

- **PRD-first approach paid off.** Having all file contents specified in the PRD made implementation fast and unambiguous — no decisions to make mid-build.
- **Pandoc + GitHub Actions is genuinely simple.** No Node, no Ruby, no local build step. The workflow is 50 lines of YAML and does exactly what it says.
- **Bilingual structure was clean to add.** `content/en/` and `content/nl/` with matching `index.md` and `nl/index.md` homepages. The language switcher nav is two lines of Markdown.
- **Shipped same session.** Concept → PRD → implementation → live site in one sitting.

---

## What was bumpy

- **PRD contained a rendering artifact.** `over-mij.md` had a malformed `/style.css">` fragment from Perplexity — caught and dropped during implementation.
- **`peaceiris/actions-gh-pages` needs `permissions: contents: write`.** Not included in the initial workflow — added after first deploy attempt failed. Required a one-time manual step in GitHub Settings too (Actions → General → Read and write permissions).
- **Back-links were initially wrong.** Content pages moved from `content/` to `content/en/` and `content/nl/`, making them 2 levels deep. Back-links pointing to `../index.html` needed updating to `../../index.html` (EN) and `../../nl/index.html` (NL).
- **CSS paths in Pandoc `--css` are relative to the output file.** Easy to get wrong across different depth levels — had to set `style.css`, `../style.css`, and `../../style.css` per build step.

---

## Decisions made

| Decision | Reason |
|----------|--------|
| Pandoc over Jekyll/Hugo | No local runtime dependency |
| `peaceiris/actions-gh-pages` over native Pages action | Simpler config; pushes to a clean `gh-pages` branch |
| English as default (`index.md` at root) | Wider reach; NL version at `nl/index.html` |
| Plain CSS, no framework | Zero build step, fully readable, long-lived |
| No JavaScript | Speed, privacy, no attack surface |

---

## Next steps (v2 backlog)

- Automatic navigation menu generated from `content/en/` and `content/nl/` file list
- Wikilinks `[[page]]` support via Pandoc Lua filter
- Client-side search (Pagefind — no server needed)
- Custom domain via CNAME + DNS
- Obsidian Git plugin for push-on-save workflow

---

*Created: 2026-03-21 15:00:00 · v01*
