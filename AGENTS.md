# Agent instructions

This file holds the rules for any agent (Claude Code, Copilot, Cursor or
another) working in this repository. `CLAUDE.md`,
`.github/copilot-instructions.md` and `.cursor/rules/agents.mdc` only point
here, so each rule is written once. For a person's view of the same workflow,
see [CONTRIBUTING.md](CONTRIBUTING.md); for the project, [README.md](README.md).

## The repository

Source of blog.naveja.us: a Hugo site with the hugo-bearblog theme as a
submodule in `themes/hugo-bearblog`, built and served by Netlify. The site is
pure static HTML and CSS; add no JavaScript and nothing that needs more than
static hosting.

## Branch names and pushing

A branch name is public the moment it is pushed, and cannot be taken back.

- Allowed names are `main` or `<prefix>/<words>`, lowercase, 40 characters at
  most. The prefixes and the exact rule are defined in
  `scripts/check-branch-name`; run it on a name before using it.
- Your local branch probably has an automatic name (`local/<task slug>`).
  Never push it under that name. Always push with an explicit refspec:

  ```sh
  scripts/check-branch-name acmm/short-name
  git push origin HEAD:refs/heads/acmm/short-name
  ```

- Open pull requests with `gh pr create --head <name>`.
- Never skip or redirect git hooks (`--no-verify`, `git commit -n`,
  `core.hooksPath`). The guard in `.claude/hookify.branch-name-guard.local.md`
  blocks these; if it fires on legitimate work, stop and ask the person rather
  than rephrasing the command.
- Commit or push only when the person asks.

## Gates

Before calling a change done, run both and report the result:

```sh
scripts/gates.sh   # branch-name, build, feed, no-theme-edit, docs-links
tests/run          # each gate shown failing on a planted break
```

`scripts/gates.sh ensure-hugo` fetches the Hugo version pinned in
`netlify.toml` into `$TMPDIR`. If it cannot be fetched (an offline sandbox),
say so; never claim the build passed. A new gate comes with a planted-failure
suite in `tests/run`.

## The theme

Never edit `themes/hugo-bearblog`. Override a template by putting a file at the
same path in the site's `layouts/`. The `no-theme-edit` gate enforces this.

## Provenance, not attribution

- No `Co-Authored-By` trailer naming an AI, in commits or pull requests.
- Agent commits end with these trailers, filled in from their real sources at
  commit time, never guessed:

  ```text
  Assisted-by: <model id> via claude-code/<version>
  Agent-Effort: <level>
  ```

- Commits are signed. Pull requests use `.github/pull_request_template.md` and
  end with its collapsed Provenance block.
- One change per pull request; `main` takes merge commits only.

## Writing

- Posts go in `content/blog/`, created with `hugo new blog/<slug>.md`, on a
  `post/<slug>` branch. Content is CC BY 4.0; code is Apache-2.0.
- Reusable prompts and the person's corrections are recorded as described in
  [docs/prompts/README.md](docs/prompts/README.md).

## Security and review tiers

[SECURITY-AI.md](SECURITY-AI.md) lists what an agent may and may not do
here; [docs/risk-tiers.md](docs/risk-tiers.md) says which review a change
needs, and `.github/labeler.yml` labels pull requests to match.

## Files kept for compatibility

These exist so Hive's ACMM scan finds them; nothing here depends on them.

- `.github/auto-qa-tuning.json`: static. No tuner or `auto-qa` workflow runs.
- `.github/workflows/ai-fix.yml`: acknowledges the `ai-fix` label and routes
  the issue to a person. No agent runs in CI.

## Steps only the person can take

The agent sandbox cannot write `.git/config`, `.claude/settings*.json` or
`.claude/skills`, and cannot change GitHub settings. Hand these to the person
instead of working around them.
