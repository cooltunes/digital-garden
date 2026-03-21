# MANUAL-01: Digital Garden Setup — Obsidian → GitHub Pages

A complete guide to replicating this setup from scratch. No prior DevOps knowledge required.

---

## What this is

A **digital garden** is a personal website where you publish notes, ideas, and writing — less polished than a blog, more public than a private notebook. This setup lets you write in Obsidian (or any Markdown editor), push to GitHub, and have a clean static website update automatically. No CMS, no subscription, no local build tool.

---

## Why this setup?

Most static site generators (Jekyll, Hugo, Astro, Next.js) require a local runtime installed on your machine — Ruby, Go, or Node.js — plus a build pipeline you have to maintain. This adds friction every time you want to publish.

This setup removes all of that:

| Principle | How |
|-----------|-----|
| No local toolchain | Pandoc runs in GitHub Actions (cloud), not on your machine |
| No framework to maintain | Plain HTML + one CSS file |
| Free hosting | GitHub Pages |
| One-command publish | `git push` triggers everything |
| Long-lived | Plain HTML and CSS don't break. This will still work in 10 years. |
| Privacy-respecting | No JavaScript, no trackers, no cookies |

The tradeoff: no dynamic features (search, comments, server-side logic) in v1. For a personal garden of notes, that's fine.

---

## Tech stack

| Layer | Tool | Why |
|-------|------|-----|
| Writing | Obsidian (or any Markdown editor) | Portable `.md` files, no lock-in |
| Conversion | [Pandoc](https://pandoc.org/) | Best-in-class Markdown → HTML; runs anywhere |
| Automation | GitHub Actions | Free CI/CD; runs on every `git push` |
| Hosting | GitHub Pages | Free, fast, HTTPS by default |
| Styling | Plain CSS | No build step, fully readable, easy to customise |
| Deployment | [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages) | Pushes built files to `gh-pages` branch cleanly |

---

## File structure

```
your-garden/
├── index.md                        ← Default (EN) homepage
├── style.css                       ← Global stylesheet
├── nl/
│   └── index.md                    ← Dutch homepage (optional)
├── content/
│   ├── en/
│   │   ├── about.md
│   │   └── note-title.md
│   └── nl/
│       ├── over-mij.md
│       └── notitie-titel.md
└── .github/
    └── workflows/
        └── deploy.yml              ← Build + deploy pipeline
```

The `_site/` folder is built by GitHub Actions and **never committed** to `main`.

---

## Step-by-step setup

### 1. Create the GitHub repository

1. Go to [github.com](https://github.com) → **New repository**
2. Name it (e.g. `digital-garden`)
3. Set to **Public** (required for free GitHub Pages)
4. Do not initialise with a README
5. Copy the repo URL

### 2. Create the files locally

Create the following files on your machine:

#### `index.md`
```markdown
---
title: Your Name · Digital Garden
---

<nav>[NL](nl/index.html)</nav>

# Your Name

A short description of who you are and what this garden is about.

---

## Notes

- [About me](content/en/about.html)
- [First note](content/en/first-note.html)

---

*Your location*
```

#### `nl/index.md` *(omit if monolingual)*
```markdown
---
title: Jouw Naam · Digital Garden
---

<nav>[EN](../index.html)</nav>

# Jouw Naam

Een korte omschrijving van wie je bent en wat deze tuin is.

---

## Notities

- [Over mij](../content/nl/over-mij.html)
- [Eerste notitie](../content/nl/eerste-notitie.html)

---

*Jouw stad*
```

#### `style.css`
```css
:root {
  --text: #1a1a1a;
  --bg: #fafaf8;
  --accent: #555;
  --max-width: 640px;
}

* { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: Georgia, serif;
  font-size: 1.1rem;
  line-height: 1.75;
  color: var(--text);
  background: var(--bg);
  padding: 4rem 1.5rem;
  max-width: var(--max-width);
  margin: 0 auto;
}

h1 { font-size: 1.6rem; font-weight: normal; margin-bottom: 1.5rem; letter-spacing: -0.02em; }
h2 { font-size: 1rem; font-weight: normal; text-transform: uppercase; letter-spacing: 0.08em; color: var(--accent); margin: 2.5rem 0 0.75rem; }

p { margin-bottom: 1rem; }

a { color: var(--text); text-decoration: underline; text-underline-offset: 3px; }
a:hover { color: var(--accent); }

hr { border: none; border-top: 1px solid #ddd; margin: 2rem 0; }

ul { list-style: none; padding: 0; }
ul li { margin-bottom: 0.5rem; }
ul li::before { content: "→ "; color: var(--accent); }

em { color: var(--accent); font-style: normal; font-size: 0.9rem; }

nav { font-size: 0.85rem; margin-bottom: 3rem; color: var(--accent); }
nav a { color: var(--accent); }

.back { display: block; margin-bottom: 2rem; font-size: 0.85rem; }
```

#### `content/en/about.md`
```markdown
---
title: About me
---

<a class="back" href="../../index.html">← Back</a>

# About me

Write about yourself here.
```

#### `content/nl/over-mij.md` *(omit if monolingual)*
```markdown
---
title: Over mij
---

<a class="back" href="../../nl/index.html">← Terug</a>

# Over mij

Schrijf hier over jezelf.
```

#### `.github/workflows/deploy.yml`
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

permissions:
  contents: write

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Install Pandoc
        run: sudo apt-get install -y pandoc

      - name: Build site
        run: |
          mkdir -p _site/nl _site/content/en _site/content/nl
          cp style.css _site/style.css

          # English homepage (default)
          pandoc index.md \
            --standalone \
            --css style.css \
            -o _site/index.html

          # Dutch homepage
          pandoc nl/index.md \
            --standalone \
            --css ../style.css \
            -o _site/nl/index.html

          # English content pages
          for f in content/en/*.md; do
            [ -f "$f" ] || continue
            filename=$(basename "${f%.md}")
            pandoc "$f" \
              --standalone \
              --css ../../style.css \
              -o "_site/content/en/${filename}.html"
          done

          # Dutch content pages
          for f in content/nl/*.md; do
            [ -f "$f" ] || continue
            filename=$(basename "${f%.md}")
            pandoc "$f" \
              --standalone \
              --css ../../style.css \
              -o "_site/content/nl/${filename}.html"
          done

      - name: Deploy to gh-pages
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./_site
```

> **Note:** If you only need one language, remove the `nl/` sections from the workflow and delete the `nl/` folder.

---

### 3. Push to GitHub

```bash
cd your-garden
git init
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO.git
git add .
git commit -m "init: digital garden"
git push -u origin main
```

### 4. Enable Actions write permissions

GitHub Actions needs write access to create the `gh-pages` branch:

1. Go to your repo → **Settings**
2. Left sidebar: **Actions → General**
3. Scroll to **Workflow permissions**
4. Select **Read and write permissions**
5. Click **Save**

### 5. Trigger the first build

Push any change to `main` (or re-run the workflow manually from the **Actions** tab). This creates the `gh-pages` branch. Wait for the green checkmark.

### 6. Enable GitHub Pages

1. Repo → **Settings → Pages**
2. Under *Build and deployment*, set **Source** to `Deploy from a branch`
3. Set **Branch** to `gh-pages`, folder `/  (root)`
4. Click **Save**

Your site is now live at:
```
https://YOUR-USERNAME.github.io/YOUR-REPO/
```

---

## Daily workflow

```bash
# Copy a note from your Obsidian vault
cp ~/vault/my-note.md ./content/en/my-note.md

# Add back-link at the top of the note
# <a class="back" href="../../index.html">← Back</a>

# Add the note to index.md
# - [My note](content/en/my-note.html)

# Push
git add .
git commit -m "add: my-note"
git push
```

GitHub Actions runs (~1 minute), Pandoc builds the HTML, site updates.

---

## Adding a new note checklist

- [ ] Write the note as a `.md` file
- [ ] Add frontmatter: `title: Note title`
- [ ] Add a back-link at the top: `<a class="back" href="../../index.html">← Back</a>`
- [ ] Place in `content/en/` (or `content/nl/`)
- [ ] Add a link to it in `index.md` (or `nl/index.md`)
- [ ] `git push`

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Workflow fails with permission error | Settings → Actions → General → Read and write permissions |
| Site not updating | Check the Actions tab for build errors |
| CSS not loading | Check `--css` path depth in `deploy.yml` matches the folder depth |
| `gh-pages` branch not created | Trigger the workflow at least once after enabling write permissions |
| Blank page | Pandoc `--standalone` flag may be missing in the workflow step |

---

## v2 ideas

- **Auto nav menu** — Bash script generates a nav list from all `.md` files in `content/en/`
- **Wikilinks** — Pandoc Lua filter converts `[[page]]` to `[page](page.html)`
- **Search** — [Pagefind](https://pagefind.app/) (client-side, no server)
- **Custom domain** — Add a `CNAME` file with your domain; configure DNS at your registrar
- **Obsidian Git plugin** — Auto-push on save, no terminal needed

---

*Created: 2026-03-21 15:05:00 · v01*
