# Risk tiers

Which changes need which review. A change takes the highest tier among the
paths it touches, and each tier's review includes every tier below it. The
`labeler` workflow adds the labels shown, from
[.github/labeler.yml](../.github/labeler.yml); a label prompts the reviewer
and decides nothing. Item numbers refer to
[docs/review-rubric.md](review-rubric.md).

| Tier | Touches | Labels |
|---|---|---|
| 1 | Posts and documentation: `content/`, `static/`, `archetypes/`, `docs/`, root Markdown other than `AGENTS.md`, `CLAUDE.md` and `SECURITY-AI.md` | `content`, `documentation` |
| 2 | Site templates and build settings: `layouts/`, `hugo.toml`, `netlify.toml` | `layouts` |
| 3 | Agent configuration: `AGENTS.md`, `CLAUDE.md`, `SECURITY-AI.md`, `.claude/`, `.cursor/`, `.github/copilot-instructions.md`, `.humanlayer/` | `agent-config` |
| 4 | Gates and workflows: `scripts/`, `tests/`, `.githooks/`, `.github/`, including `.github/rulesets/` | `gates`, `workflows` |
| 5 | The theme: `themes/`, `.gitmodules` | `theme` |

## What each tier needs

- **Tier 1.** Gates green; rubric items 1 to 8, and P1 to P5 for a post.
- **Tier 2.** Also: the deploy preview checked in light and dark mode, the feed
  still full (`feed` gate), and no JavaScript (item 5). Templates here are
  overrides of the theme's, so compare with the theme file they replace.
- **Tier 3.** Also: a pointer file adds no rule of its own (AGENTS.md holds
  them); a hook rule is tested against something it must catch and something
  it must let through. These files steer agents, so a wrong one misleads every
  later session.
- **Tier 4.** Also: every gate added or changed shows its planted failure
  caught (item 3), and items W1 to W4. A change in `.github/rulesets/` needs
  the matching change applied on GitHub by a person.
- **Tier 5.** Only a deliberate theme update, in its own pull request, moving
  the submodule and `THEME_PIN` in `scripts/gates.sh` together (README,
  "Updating the theme"). Any other change is refused by `no-theme-edit`.
