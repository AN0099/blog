# Prompts and corrections

Two records that make agent work repeatable: prompts that worked, and
corrections the person had to make. Rules that come out of either belong in
[AGENTS.md](../../AGENTS.md).

## Prompts catalog

One entry per prompt worth reusing. Keep the prompt short and the expected
result concrete.

| Prompt | Use it for | Expected result |
|---|---|---|
| `Run scripts/gates.sh and tests/run and report each gate's result.` | Checking any change before a pull request | Every gate passes, or the failing gate and its message |
| `Draft a post at content/blog/<slug>.md from these notes; keep it a draft.` | Starting a post | A draft from `archetypes/blog.md`, on a `post/<slug>` branch |
| `Override <template> in layouts/ to <change>; do not touch the theme.` | Any template change | A file under `layouts/`, with `no-theme-edit` still passing |
| `Push this as <prefix>/<name> and open a pull request from the template.` | Publishing work | An explicit-refspec push, then `gh pr create --head <prefix>/<name>` |

## Correction capture

When the person corrects an agent, record it so the correction is made once.
Add an entry under Entries (newest first) in this format:

```text
### YYYY-MM-DD: <one-line summary>
- What happened: <what the agent did>
- Correction: <what the person said or did instead>
- Rule: <the rule it implies, or "none">
- Applied in: <AGENTS.md section, gate or guard that now holds it, or "pending">
```

A correction that implies a lasting rule moves into AGENTS.md, a gate, or the
agent guard in the same pull request, and its entry says where.

### Entries

_None yet._
