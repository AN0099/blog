# Review rubric

What a reviewer (the person, or an agent asked to review) checks on a pull
request before it merges into `main`. The rules themselves live in
[AGENTS.md](../AGENTS.md) and [CONTRIBUTING.md](../CONTRIBUTING.md); this is
the checklist that applies them. Gates catch what a script can; the rest is
judgement.

Each item is **pass**, **fail**, or **n/a**. Any fail blocks the merge until it
is fixed or the person explicitly accepts it in the review.

## Every pull request

| # | Check | How to tell |
|---|---|---|
| 1 | One change, and the description says what changes for a reader or contributor | Read the diff against the "What and why" section |
| 2 | Required checks are green: `branch-name`, `gates`, `Analyze (actions)` | The PR's checks list |
| 3 | `tests/run` covers any new or changed gate with a planted failure | A new `gate_*` in `scripts/gates.sh` has a suite in `tests/run` |
| 4 | Theme submodule untouched; template changes are overrides in `layouts/` | `no-theme-edit` gate, and no `themes/` entry in the diff |
| 5 | No JavaScript, no external runtime service; the site stays static HTML and CSS | No `<script>`, no new third-party URL loaded at view time |
| 6 | Commits are signed and carry provenance trailers, not an AI `Co-Authored-By` | `git log --show-signature`; trailers per AGENTS.md |
| 7 | The Provenance block in the PR template is filled in | Bottom of the PR description |
| 8 | Docs follow the change: README, CONTRIBUTING, AGENTS.md, or these docs | A changed workflow, gate, or command is described where people look for it |

## Posts (`post/<slug>` branches)

| # | Check | How to tell |
|---|---|---|
| P1 | Front matter complete: `title`, `date`, `tags`, `draft = false` when ready | Compare with `archetypes/blog.md` |
| P2 | Reads correctly in the deploy preview, light and dark mode | Netlify deploy preview |
| P3 | Images live under `static/images/`, have alt text, and are licensed for reuse under CC BY 4.0 | The diff and the source of each image |
| P4 | The post appears in full in `/index.xml` | The `feed` gate; optionally a feed reader |
| P5 | Permalinks of existing posts are unchanged | No slug or `[permalinks]` change unless the PR is about that |

## Workflows and settings (`.github/`)

| # | Check | How to tell |
|---|---|---|
| W1 | Actions pinned by full commit SHA, with the version in a comment | `uses:` lines |
| W2 | Least `permissions:`; `persist-credentials: false` on checkout | Workflow YAML |
| W3 | No agent runs inside CI; untrusted input never reaches a `run:` line unquoted | Pass event data through `env:` |
| W4 | A ruleset change in `.github/rulesets/` is also applied in GitHub (or listed as a manual step) | PR description |

## Recording the review

Leave the verdict as a review comment: the failing item numbers, or "rubric
pass". A correction the person had to make goes into
[docs/prompts/README.md](prompts/README.md) under Correction capture.
