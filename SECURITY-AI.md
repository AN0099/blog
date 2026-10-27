# Security for AI agents

What an AI agent may and may not do in this repository. Each rule restates
[AGENTS.md](AGENTS.md), [CONTRIBUTING.md](CONTRIBUTING.md) or
[docs/control-layers.md](docs/control-layers.md); this file adds none.

## An agent may

- Edit files in a worktree, run `scripts/gates.sh` and `tests/run`, and report
  what they showed.
- Commit and push only when the person asks: signed, with the provenance
  trailers AGENTS.md lists, to a name `scripts/check-branch-name` accepts,
  always with an explicit `HEAD:refs/heads/<name>` refspec.
- Open a pull request with `--head` given, using the template and its
  Provenance block.

## An agent may not

- Merge, push to `main`, tag, or change repository settings or rulesets. The
  `main` ruleset refuses direct pushes, and the agent cannot change settings.
- Push its local task branch under its automatic name.
- Skip or redirect git hooks (`--no-verify`, `git commit -n`,
  `core.hooksPath`), or rephrase a command a guard blocked. Stop and ask.
- Edit `themes/hugo-bearblog`, or add JavaScript or anything beyond static
  hosting to the site.
- Put AI attribution in a commit or pull request, or type provenance values
  instead of reading them from their sources.
- Write `.git/config`, `.claude/settings*.json` or `.claude/skills`.
- Report its own work as verified. CI and the person merging are the second
  party.

## Agents in CI

No agent runs in CI and no workflow holds a model credential.
`.github/workflows/ai-fix.yml` only acknowledges the `ai-fix` label and
routes the issue to a person; a fix arrives later as a pull request from an
agent session, under the usual review. `labeler.yml` uses
`pull_request_target` and never checks out the pull request's code.

## Limits an agent works inside

The sandbox, the guard and the GitHub rulesets are described in
[docs/control-layers.md](docs/control-layers.md), with what each one stops.
The guard is pattern-based and is not a boundary on its own.

## Reporting a vulnerability

Use GitHub's private vulnerability reporting (Security, Report a
vulnerability) rather than a public issue.
