# Contributing

This is the source of [blog.naveja.us](https://blog.naveja.us/), a Hugo site
using the hugo-bearblog theme as a git submodule. Netlify builds and serves it.

## Set up

```sh
git clone --recurse-submodules https://github.com/AN0099/blog.git
cd blog
git config core.hooksPath .githooks   # checks branch names before a push
```

Use Hugo extended at the version pinned in `netlify.toml` (`HUGO_VERSION`).
`scripts/gates.sh ensure-hugo` downloads that version, checks it against the
release's checksums, and unpacks it into `$TMPDIR/hugo-<version>/`. Put that
directory first on your `PATH` if your own Hugo is a different version.

## Preview

```sh
hugo server -D        # http://localhost:1313, drafts included
```

## A new post

```sh
hugo new blog/my-post.md
```

This uses `archetypes/blog.md` and starts as a draft. The post is served at
`/<slug>/`. Set `draft = false` when it is ready.

## Gates

Before you push, run:

```sh
scripts/gates.sh      # branch name, build, feed, theme untouched, doc links
tests/run             # proves each gate fails on a planted break
```

CI runs the same script on every pull request (`.github/workflows/ci.yml`)
and every night (`.github/workflows/nightly.yml`).

## Branch names

Names come from a fixed vocabulary defined in `scripts/check-branch-name`:
`<prefix>/<words>`, where the prefix is one of
`feat fix docs chore acmm ci test licence post`, the words are lowercase and
joined by hyphens, and the whole name is 40 characters at most. Use
`post/<slug>` for writing.

If your local branch has another name (a task worktree, for example), push it
under an allowed name:

```sh
git push origin HEAD:refs/heads/post/my-post
```

## The theme

Never edit `themes/hugo-bearblog`. To override a template, put a file at the
same path in the site's `layouts/`. The `no-theme-edit` gate fails on any
change inside the submodule. README.md describes how to update the theme on
purpose.

## Pull requests

One change per pull request, with signed commits. Fill in the template,
including the Provenance block.
