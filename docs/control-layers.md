# Control layers

Each rule in this repository is enforced at more than one layer, so a rule
that slips past one is caught by the next. The layers run from earliest and
cheapest to latest and hardest to bypass. A rule is defined once (usually a
script) and every layer calls that definition, so the layers cannot disagree.

| Layer | Where | Who it stops | Can be bypassed by |
|---|---|---|---|
| 1. Instructions | [AGENTS.md](../AGENTS.md), [CONTRIBUTING.md](../CONTRIBUTING.md) | An agent or person who reads first | Not reading them |
| 2. Agent guard | `.claude/hookify.branch-name-guard.local.md` | An agent about to run a forbidden command | Agents without the guard |
| 3. Local hook | `.githooks/pre-push` (after `git config core.hooksPath .githooks`) | A bad push from this clone | A clone without the hook set |
| 4. CI | `.github/workflows/{branch-name,ci,codeql,nightly,labeler,ai-fix}.yml` | A PR that breaks a gate | Nothing, once checks are required |
| 5. GitHub rulesets | `.github/rulesets/{branch-names,main}.json`, applied in GitHub | Bad branch names, unsigned or unchecked merges, force pushes | Repository admins only |
| 6. Review | [docs/review-rubric.md](review-rubric.md) | What no script can judge | The person merging |

## Rules and the layers that hold them

| Rule | Defined in | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|---|
| Branch names from the fixed vocabulary | `scripts/check-branch-name` | yes | yes | yes | yes | yes | |
| No skipping hooks | AGENTS.md | yes | yes | | | | |
| Site builds at the pinned Hugo | `scripts/gates.sh build` | yes | | | yes | yes | |
| Feed carries full posts | `scripts/gates.sh feed` | yes | | | yes | yes | |
| Theme never edited | `scripts/gates.sh no-theme-edit` | yes | | | yes | yes | yes |
| Doc links resolve | `scripts/gates.sh docs-links` | yes | | | yes | yes | |
| Signed commits, merge commits only | `.github/rulesets/main.json` | yes | | | | yes | yes |
| No JavaScript; static hosting only | AGENTS.md | yes | | | | | yes |
| Provenance trailers, no AI `Co-Authored-By` | AGENTS.md | yes | | | | | yes |

Layer 5 holds the gate rules through required checks: `main` will not take a
PR whose `gates` check failed.

## Adding a rule

1. Write the rule once, as a script or a gate in `scripts/gates.sh`, with a
   planted-failure suite in `tests/run`.
2. Describe it in AGENTS.md (and CONTRIBUTING.md if people need it).
3. Call it from every layer that can run it; make its check required if it
   protects `main`.
4. Add a row above. A rule held only by layers 1 and 6 is a candidate for a
   gate.
