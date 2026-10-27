# Bridle Works dev blog

[![Netlify Status](https://api.netlify.com/api/v1/badges/13893d4c-0fe0-4f19-a060-c2a6f7a193d9/deploy-status)](https://app.netlify.com/projects/bridleworks/deploys)

Source for [blog.naveja.us](https://blog.naveja.us/), the development blog of
Bridle Works and AN0099. Hugo with the hugo-bearblog theme (a git submodule),
built and served by Netlify on every push.

Clone with `git clone --recurse-submodules` so the theme comes with it.

## Preview locally

```sh
hugo server -D
```

The site is served at http://localhost:1313 with drafts included and reloads
on save.

## Write a post

```sh
hugo new blog/my-post.md
```

The post starts as a draft from `archetypes/blog.md` and is published at
`/<slug>/`. Set `draft = false` when it is ready.

## Hugo version

The one pin is `HUGO_VERSION` in `netlify.toml`, currently **0.167.0**
(extended). Netlify, CI and `scripts/gates.sh` all read it from there.
`scripts/gates.sh ensure-hugo` fetches that release, verifies its checksum,
and unpacks it into `$TMPDIR/hugo-<version>/`. To move to a new Hugo version,
change the pin, run `scripts/gates.sh`, and check the deploy preview.

## Checks

```sh
scripts/gates.sh   # branch name, build, feed, theme untouched
tests/run          # shows each gate failing on a planted break
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch names and pull requests.

## Updating the theme

The theme in `themes/hugo-bearblog` is never edited here; site changes go in
`layouts/`. To move it to a newer upstream commit:

```sh
git -C themes/hugo-bearblog fetch
git -C themes/hugo-bearblog checkout <commit>
```

Then set `THEME_PIN` in `scripts/gates.sh` to the same commit, run the gates,
compare any overridden files in `layouts/` with the new upstream versions, and
commit the submodule and the pin together.

## Licenses

- Code (templates, scripts, configuration): [Apache-2.0](LICENSE).
- Content (posts and pages in `content/`, and images in `static/images/`):
  [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
- The hugo-bearblog theme keeps its own license, in its submodule.
