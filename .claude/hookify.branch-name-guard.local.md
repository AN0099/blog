---
name: branch-name-guard
enabled: true
event: bash
action: block
tool_matcher: Bash
conditions:
  - field: command
    operator: regex_match
    pattern: '\bgit\b[^\n;&|]*\s(--no-verify\b|\S*core\.hooks[Pp]ath)|\bgit\b[^\n;&|]*\bcommit\b[^\n;&|]*\s-[a-zA-Z]*n[a-zA-Z]*(\s|$)|\bgit\b(\s+-c\s+\S+)*\s+push\b(?![^\n;&|]*:)|\bgh\s+pr\s+create\b(?![^\n;&|]*\s--head[\s=])'
---

**Blocked: this git command could publish a branch name nobody chose, or skip the check that stops one.**

An agent pushes only with an explicit refspec that names the destination branch, and never skips or redirects git hooks. The allowed names are defined in `scripts/check-branch-name`.

This rule exists because of a near miss in AN0099/chocolate-factory on 2026-10-22. `git push -u origin HEAD` published a HumanLayer task branch under its automatic name: a 54-character sentence fragment taken from the opening words of the task's request. A branch name is public the moment it is pushed, and copies of public push events persist outside GitHub, so deleting the branch afterwards does not take the name back.

**What this blocks:**

1. `git push` without a `:` refspec, such as `git push`, `git push origin HEAD`, `git push -u origin HEAD`, `git push origin <branch>` or `git push --all`. Each of these takes the remote name from whatever the local branch happens to be called.
2. `--no-verify` on any git command, and `git commit -n`. These skip `.githooks/pre-push` and the commit hooks.
3. Any git command naming `core.hooksPath`, including `git -c core.hooksPath=...`. This would redirect or disable the hooks.
4. `gh pr create` without `--head`. Without it, `gh` can push the current branch under its own name.

The cases this rule must block and allow are in `tests/branch-guard-cases.tsv`, and `scripts/check-branch-guard` tests this file's pattern against them.

**Do this instead:** choose a name that passes `scripts/check-branch-name`, then push to it explicitly:

    scripts/check-branch-name chore/short-name
    git push origin HEAD:refs/heads/chore/short-name

To delete a remote branch, use `git push origin :refs/heads/<name>`, which this rule allows.

**If it fired on text, not a command:** the rule reads the whole command line, including a heredoc or `--body` that only describes these commands, such as a PR description. Write that text to a file with the file-writing tool and pass the path, for example `--body-file`. That moves prose out of the command. It is not a way around the rule: the command that runs must still pass.

**If this fired on legitimate work,** the person decides. Do not rephrase the command to get past the pattern.
