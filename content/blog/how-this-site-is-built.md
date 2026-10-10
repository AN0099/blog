+++
title = "How this site is built"
date = "2026-10-08"
description = "Hugo, a theme as a git submodule, and Netlify building on every push."
tags = ["hugo", "netlify", "static-site"]
+++

# How this site is built

The setup is carried over from the personal blog this site replaced. It has
worked without attention since 2024, which is the best thing a blog's
plumbing can do.

- **Plain Markdown in a git repository.** Each post is one file. The history
  of the site is the repository's history.
- **[Hugo](https://gohugo.io/) with the
  [hugo-bearblog](https://github.com/janraasch/hugo-bearblog) theme**, which
  follows [Bear Blog](https://bearblog.dev/): pages of a few kilobytes, no
  scripts, no tracking.
- **The theme is a git submodule**, so it can be updated or pinned without
  copying its files into this repository.
- **[Netlify](https://www.netlify.com/) builds and serves the site** whenever
  the repository changes. There is no server to look after.

## The one thing that did not work

Netlify's Hugo quickstart template would not build with this theme, whatever
was tried. What worked was starting from nothing: an empty repository, a new
Hugo site inside it, the theme added as a submodule, and the theme's example
content copied in as a starting point. Netlify built that on the first push.
