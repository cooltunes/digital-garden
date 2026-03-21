<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# Create a full PRD for this solution  that needs to be published at [https://github.com/cooltunes/digital-garden](https://github.com/cooltunes/digital-garden)  include the code you wrote about. And start by explaining the concept: Publishing from obsidian the .md pages to GitHub to be published in a good looking minimal html website (just static html pages) in Github pages

Hier is de volledige PRD:

***

# PRD: Digital Garden — Obsidian → GitHub Pages

**Repository:** `github.com/cooltunes/digital-garden`
**Versie:** 1.0
**Datum:** 21 maart 2026

***

## Concept

Het idee is simpel: je schrijft en beheert notities in **Obsidian** als gewone `.md` bestanden. Door ze te pushen naar een GitHub-repo worden ze automatisch omgezet naar **statische HTML-pagina's** met een minimalistisch design, en geserveerd via **GitHub Pages** — zonder dashboard, CMS, abonnement of lokale buildtool.

De pipeline gebruikt uitsluitend **Pandoc** (draait in GitHub Actions) om Markdown te converteren naar HTML. Er is geen framework, geen Node.js, geen build-stap op je eigen machine. Jij pusht `.md` — de rest gebeurt in de cloud.


---

## Doelstellingen

- Publiceren vanuit Obsidian met één `git push`
- Geen lokale toolchain vereist behalve Git
- Volledig statische output (plain HTML + CSS)
- Minimalistisch, leesbaar design gebaseerd op typografie
- Gratis hosting via GitHub Pages
- Uitbreidbaar: nieuwe pagina = nieuw `.md` bestand

***

## Non-doelen

- Geen zoekfunctie (v1)
- Geen Obsidian-specifieke syntax zoals `[[wikilinks]]` (v1)
- Geen CMS of admin interface
- Geen database of server-side logica
- Geen Obsidian Publish abonnement

***

## Bestandsstructuur example

```
cooltunes/digital-garden/
├── index.md                        ← homepage
├── style.css                       ← globale styling
├── content/
│   ├── over-mij.md
│   ├── notitie-1.md
│   └── notitie-2.md
└── .github/
    └── workflows/
        └── deploy.yml              ← GitHub Actions pipeline
```

De `_site/` map wordt automatisch aangemaakt door de Action en **niet** gecommit naar `main`.

***

## Alle Bestanden — Volledige Code

### `index.md`

```markdown
---
title: Bram · Digital Garden
---

>

# Bram

UX Strateeg en Systemic Designer uit Amsterdam.
Ik los maatschappelijke en technische uitdagingen op —
nieuwsgierig naar wat nieuwe technologieën zoals GenAI
ons daarbij kunnen bieden, zonder de mens uit het oog te verliezen.

---

## Verkenningen

- [Over mij](content/over-mij.html)
- [Notitie 1](content/notitie-1.html)
- [Notitie 2](content/notitie-2.html)

---

*Amsterdam · Lelystad*
```


***

### `style.css`

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

h1 {
  font-size: 1.6rem;
  font-weight: normal;
  margin-bottom: 1.5rem;
  letter-spacing: -0.02em;
}

h2 {
  font-size: 1rem;
  font-weight: normal;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--accent);
  margin: 2.5rem 0 0.75rem;
}

p { margin-bottom: 1rem; }

a {
  color: var(--text);
  text-decoration: underline;
  text-underline-offset: 3px;
}
a:hover { color: var(--accent); }

hr { border: none; border-top: 1px solid #ddd; margin: 2rem 0; }

ul { list-style: none; padding: 0; }
ul li { margin-bottom: 0.5rem; }
ul li::before { content: "→ "; color: var(--accent); }

em {
  color: var(--accent);
  font-style: normal;
  font-size: 0.9rem;
}

nav {
  font-size: 0.85rem;
  margin-bottom: 3rem;
  color: var(--accent);
}
nav a { color: var(--accent); }

.back { display: block; margin-bottom: 2rem; font-size: 0.85rem; }
```


***

### `.github/workflows/deploy.yml`

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

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
          mkdir -p _site/content
          cp style.css _site/style.css

          # Build homepage
          pandoc index.md \
            --standalone \
            --metadata title="Digital Garden" \
            --css style.css \
            -o _site/index.html

          # Build content pages
          for f in content/*.md; do
            [ -f "$f" ] || continue
            filename=$(basename "${f%.md}")
            pandoc "$f" \
              --standalone \
              --css ../style.css \
              -o "_site/content/${filename}.html"
          done

      - name: Deploy to gh-pages
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./_site
```


***

### `content/over-mij.md` (voorbeeldpagina)

```markdown
---
title: Over mij
---

/style.css">
<a class="back" href="../index.html">← Terug</a>

# Over mij

Ik ben Bram, UX Strateeg en Systemic Designer uit Amsterdam.
Ik combineer analytisch denken met een onderzoekende houding —
in mijn werk én in mijn vrije tijd.

---

## Wat ik doe

Ik werk aan de snijvlakken van design, technologie en maatschappij.
Levenslang leren, scherpe vragen stellen en de wereld actief verkennen
zijn de rode draden in alles wat ik doe.
```


***

## Eenmalige Setup op GitHub

1. Maak de repo `cooltunes/digital-garden` aan op GitHub (public)
2. Push alle bestanden naar de `main` branch
3. Ga naar **Settings → Pages**
4. Zet **Source** op: `Deploy from a branch` → branch `gh-pages` → `/ (root)`
5. Sla op — na de eerste push is de site live op `https://cooltunes.github.io/digital-garden`

***

## Dagelijkse Workflow

```bash
# Vanuit je Obsidian vault-map:
cp mijn-notitie.md ~/digital-garden/content/
cd ~/digital-garden
git add .
git commit -m "add: mijn-notitie"
git push
```

GitHub Actions draait automatisch (~1 minuut), Pandoc bouwt de HTML, en de site is bijgewerkt.

***

## Uitbreidingen (v2+)

| Feature | Aanpak |
| :-- | :-- |
| Wikilinks `[[pagina]]` support | Pandoc Lua-filter of sed preprocessing |
| Automatisch navigatiemenu | Bash-script genereert nav-HTML voor de build |
| Zoekfunctie | Pagefind (client-side, geen server nodig) |
| Eigen domein | CNAME bestand + DNS instellen bij provider |
| Obsidian Git plugin | Auto-push bij opslaan, geen terminal nodig |


***

## Technische Beslissingen

| Keuze | Reden |
| :-- | :-- |
| Pandoc i.p.v. Jekyll/Hugo | Geen lokale Ruby/Go installatie nodig |
| GitHub Actions | Build draait in de cloud, niet lokaal |
| Plain CSS | Geen build-stap, volledig controleerbaar |
| `gh-pages` branch | Standaard GitHub Pages mechanisme, clean scheiding van source en output |
| Geen JavaScript | Maximale snelheid, privacy, duurzaamheid |
