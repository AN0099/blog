# Session summary format

At the end of an agent session that changed the repository, the agent writes
a summary in this format: in the pull request description (above the
Provenance block) or, for work that is not yet a pull request, as its final
message to the person. It is a record for the person, so it reports what
happened, including what failed or was skipped. It never claims a check passed
that was not run.

```markdown
## Session summary

- Task: <issue, task slug, or one-line request>
- Branch: <pushed name, e.g. acmm/quality> (local: <local name, if different>)
- Changed: <files or areas, one line each, with why>
- Gates: scripts/gates.sh <pass | fail: gate and message | not run: reason>
- Tests: tests/run <pass | fail: suite | not run: reason>
- Not done: <anything left out, and why>
- For the person: <steps only the person can take: GitHub settings,
  .claude/settings.json, .git/config, manual checks>
- Corrections: <corrections received this session, recorded in
  docs/prompts/README.md, or "none">
```

Keep each line short. If a line does not apply, write "none" rather than
deleting it, so a missing step is visible.
