# CLAUDE.md — AI Collaboration Instructions

> These instructions apply to all projects using this repository. Read this file first before doing anything else.

---

## 1. First Things First: Directory Scan

Before starting any task, always:
1. Scan the entire project directory to understand its structure.
2. Identify key folders: design system, components, content, prototypes, config files.
3. Read any existing `_comms/PRD/` files to understand prior planning.
4. Summarize your findings before proposing any plan.

---

## 2. Working File Conventions

Claude operates within a structured communication system. Use the `_comms/` folder for all planning and output artifacts:

| Purpose | Location | Naming convention |
|---|---|---|
| Plans & PRDs | `_comms/01_PRD/` | `{ID}_{YYYYMMDD}_{slug}_v##.md` |
| Active task breakdowns | `_comms/02_TASK/` | `{ID}_{YYYYMMDD}_{slug}_v##.md` |
| Completed work retrospectives | `_comms/04_RETRO/` | `{ID}_{YYYYMMDD}_{slug}_v##.md` |
| Completed task files | `_comms/03_DONE/` | `{ID}_{YYYYMMDD}_{slug}_v##.md` |

### Rules
- **Never start implementation** without a plan file written to `_comms/01_PRD/`.
- **Every task** must have a corresponding file in `_comms/02_TASK/` before work begins.
- **When a task is completed**, write a short retrospective to `_comms/04_RETRO/` (for sprints) or a DONE file in `_comms/03_DONE/` (for tasks).
- If `_comms/` does not exist yet, create the full folder structure before proceeding.

---

## The Loop: Plan → Track → Execute → Feedback

Every non-trivial task follows this four-step cycle. Keep it lean — no unnecessary ceremony.

### 1. PLAN
Before starting work, create a `TASK` file in `_comms/02_TASK/`:

**Filename:** `TASK-###_{YYYYMMDD}_{slug}_v##.md` (e.g., `TASK-023_20260319_fix-nav_v01.md`)
**Header:** Include `Refs: PRD-XX, PLAN-XX` to link back to parent documents.

Contents:
- **Goal** — what we're trying to achieve
- **Scope** — what's in and out of this task
- **Steps** — ordered list of planned actions
- **Files** — files to be created or modified
- **Open questions** — anything unresolved before starting

**Important:** Add the new task to `_comms/INDEX.md` immediately.

### 2. TRACK
For larger tasks, maintain a lightweight checklist inside the TASK file:
```
- [ ] Step 1
- [x] Step 2 (done)
- [ ] Step 3
```
No separate tracking tool needed. The TASK file is the source of truth during execution.

### 3. EXECUTE
Write the code. Follow the rules in this file. Ask before deviating from the plan.

### 4. FEEDBACK
After completing work, create a `DONE` file in `_comms/03_DONE/`:

**Filename:** `DONE-###_{YYYYMMDD}_{slug}_v##.md` (Must match the TASK number)
**Header:** Include `Refs: TASK-###` to link back.

Contents:
- **What was done** — concise summary (3–5 lines max)
- **Files created** — list with paths
- **Files modified** — list with paths
- **Decisions made** — anything not in the original plan + why
- **Issues / troubleshooting** — what went wrong and how it was resolved
- **Next steps** — suggested improvements or follow-up tasks

**Important:** Update `_comms/INDEX.md` to remove the open task.

---

## File Naming Convention (`_comms/`)

Core principle: IDs come **first** so files sort naturally.

```
{ID}_{YYYYMMDD}_{slug}_v##.md
```

### ID Prefixes

| Prefix | Name | Lives in | Usage |
|--------|------|----------|-------|
| `PRD-NN` | Requirements | `01_PRD/` | Project-level scope, long-lived |
| `PLAN-NN` | Sprint plan | `01_PRD/` | Sprint-level planning |
| `TASK-NNN` | Task file | `02_TASK/` | Pre-work intent; 3-digit sort |
| `NOTES-NN` | Research/audit | `02_TASK/` | Findings, audits, decisions-in-progress |
| `ISS-NN` | Issue / blocker | `02_TASK/` | Gate failures, blockers needing resolution |
| `DONE-NNN` | Completion | `03_DONE/` | Always mirrors TASK number: DONE-012 closes TASK-012 |
| `RETRO-NN` | Retrospective | `04_RETRO/` | Sprint or milestone reflection |

Version starts at `v01`. Increment if a file is substantially revised.

### Footer Format

All PLAN, TASK, DONE, RETRO, NOTES, MANUAL, and other `_comms/` documents must include a footer with:
- **Exact date:** YYYY-MM-DD
- **Exact time:** HH:MM:SS (24-hour format)
- **Document version:** e.g., v01, v02

**Footer template:**
```
---
*Created: YYYY-MM-DD HH:MM:SS · v01*
```

Update the timestamp and version if substantially revised.

---

## 3. Planning Workflow

1. **Scan** → understand the current state of the repository.
2. **Analyze** → review prototypes, design files, content sources, and existing components.
3. **Plan** → write a PRD with goals, scope, phases, and success criteria.
4. **Break down** → decompose the PRD into individual task files in `_comms/02_TASK/`.
5. **Execute** → work task by task; check off progress in the task file.
6. **Retrospect** → write a retro file when done.

---


## 5. Code & Commit Conventions

- Use existing code style and formatting conventions in the project.
- Never remove or overwrite existing content without explicit instruction.
- Prefer small, focused changes over large rewrites.
- Comment non-obvious decisions inline.
- Ask before introducing new dependencies.

---

## 6. Communication Style

- Be concise in task files; verbose in PRDs and retros.
- Flag blockers or ambiguities explicitly — do not silently skip them.
- When making assumptions, state them clearly in the relevant document.
- If the scope grows mid-task, update the PRD and notify.


---

## 10. Agent Orchestration - For Web development

When starting a task, delegate to the right specialist rather than doing everything yourself. Use `@orchestrator` when the task spans multiple domains or you're unsure where to start.

| Task type | Agent | Skill |
|-----------|-------|-------|
| Accessibility audit (design or code) | `@accessibility-specialist` | `accessibility-audit` |
| Design tokens, visual system, colour decisions | `@ui-visual-designer` | `design-system` |
| Wireframes, spot plans, user flows | `@ux-concept-designer` | `double-diamond` |
| Component build (Astro, TypeScript, CSS) | `@frontend-developer` | `coding-standards` |
| PRD, backlog, acceptance criteria | `@product-owner` | `spec-driven-development` |
| QA, test specs, go/no-go validation | `@qa-engineer` | `testing-patterns` |
| Infrastructure, deployment, Cloudflare | `@devops` | `devops-safety` |
| Translation (EN → NL) | — | `translate-en-nl` |
| Research a topic or library | `@researcher` | `research-protocol` |
| Design system governance | `@design-ops` | `design-system` |
| Cross-domain or unclear scope | `@orchestrator` | — |

---

## 11. Phase-Gated Workflow

We always build following  a pipeline defined in `_comms/PRD/WORKFLOW.md`. The pipeline is **strictly sequential with explicit human gates**.

### Rules (non-negotiable)

1. **Do not proceed to the next stage** unless the current gate is passed — either by automated check or by explicit human approval.
2. **If a gate check fails:** stop immediately, document the failure in `_comms/TASKS/` with a `TASK` file, and surface it to the human before doing anything else.
3. **Never skip stages.** In particular:
   - ...
4. **The human must explicitly say "approved" or "proceed".** Silence is not approval.
5. **All `_comms/` artifacts must be written at each stage** — TASK file before starting, DONE file after completing. No exceptions.

### Stage → Gate summary

| # | Stage | Gate |
|---|-------|------|
| 1 | Orientation | Documented |
| 2 | Step 2 | Human ✋ |
| 3 | ...  | ... |


If the gate workflow is not complete for the project, propose a structure based on the PRD and intent of the project you just learned about.