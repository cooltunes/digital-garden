# DONE-002: Implement Core Project Files

**Refs:** TASK-002, PRD-01

## What was done
Created all source files required for the Digital Garden pipeline. The repository is now ready to be pushed to `github.com/cooltunes/digital-garden` — one `git push` to `main` will trigger the GitHub Actions workflow, Pandoc builds the HTML, and the site deploys to GitHub Pages.

## Files Created
| Path | Purpose |
|------|---------|
| `index.md` | Homepage |
| `style.css` | Global stylesheet (minimal, typography-focused) |
| `.github/workflows/deploy.yml` | Pandoc build + GitHub Pages deploy via `peaceiris/actions-gh-pages@v4` |
| `content/over-mij.md` | About page (example content) |
| `content/notitie-1.md` | Placeholder note 1 |
| `content/notitie-2.md` | Placeholder note 2 |
| `_comms/02_TASK/TASK-002_20260321_implement-core-files_v01.md` | Task file |

## Files Modified
- `_comms/INDEX.md` — updated active/completed tasks

## Decisions Made
- `over-mij.md` drops the malformed `/style.css">` fragment that appeared in the PRD (a Perplexity rendering artifact). The CSS path is handled correctly by Pandoc's `--css ../style.css` flag in the workflow.
- Placeholder notes use the same back-link pattern as `over-mij.md` for consistency.

## Issues / Troubleshooting
None.

## Next Steps
1. Create the repo `cooltunes/digital-garden` on GitHub (public).
2. Push all files to `main`.
3. Go to **Settings → Pages** → Source: `gh-pages` branch → `/ (root)`.
4. Site will be live at `https://cooltunes.github.io/digital-garden` after first Action run (~1 min).

---
*Created: 2026-03-21 14:35:00 · v01*
