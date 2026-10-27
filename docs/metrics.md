# Metrics

A few pull-request and health numbers, read from GitHub on demand. Nothing is
collected or stored; the commands below are the source of truth, so the
numbers cannot drift from reality. They are for the person's own review of
how agent-assisted work is going, not a public scoreboard.

## What is measured

| Metric | Why it matters | Healthy for this repo |
|---|---|---|
| PRs merged per month | Throughput | Whatever the writing pace is; no target |
| Time from PR open to merge | How long work waits | Under a few days |
| PRs merged with all required checks green on the first push | Whether agents run the gates before pushing | Most of them |
| PRs closed without merging | Wasted or misdirected work | Rare |
| Nightly runs green in the last 30 days | Drift outside the repo (Hugo assets, theme remote) | All |
| Open issues plus open PRs | Hive pressure | Below 9 |
| Corrections recorded | How often the person had to step in | Falling over time |

## How to read them

Run from a clone with `gh` authenticated.

```sh
# PRs merged in the last 30 days, with open-to-merge time in hours
gh pr list --state merged --search "merged:>=$(date -d '30 days ago' +%F)" \
  --json number,title,createdAt,mergedAt \
  --jq '.[] | "\(.number)\t\(((.mergedAt|fromdate)-(.createdAt|fromdate))/3600|floor)h\t\(.title)"'

# PRs closed without merging
gh pr list --state closed --search "is:unmerged" --json number,title

# Nightly results, newest first
gh run list --workflow nightly.yml --limit 30 --json conclusion,createdAt \
  --jq '.[] | "\(.createdAt)\t\(.conclusion)"'

# Pressure: open issues plus open PRs
echo $(( $(gh issue list --json number --jq length) + $(gh pr list --json number --jq length) ))
```

Corrections are counted from the Entries in
[docs/prompts/README.md](prompts/README.md). First-push check results are in
each PR's checks history.

## Using them

Look at the numbers when something feels off, or before asking Hive to raise
the repository's level. A metric that keeps going the wrong way becomes a rule
in [AGENTS.md](../AGENTS.md), a gate, or an item in
[docs/review-rubric.md](review-rubric.md).
