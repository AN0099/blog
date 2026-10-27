#!/bin/sh
# The gates every change must pass. A person, CI (.github/workflows/ci.yml and
# nightly.yml) and tests/run all call this one script, so there is one
# definition of "the site is fine".
#
# Usage: scripts/gates.sh                 run every gate, in order
#        scripts/gates.sh GATE...         run only the named gates
#        scripts/gates.sh ensure-hugo     only install/locate the pinned Hugo
#
# Gates:
#   branch-name    scripts/check-branch-name "$BRANCH" (default: current branch)
#   build          hugo --gc --minify at the version pinned in netlify.toml
#   feed           public/index.xml and public/blog/index.xml parse as RSS and
#                  every item carries the full post, with absolute links
#   no-theme-edit  themes/hugo-bearblog is clean and its gitlink is THEME_PIN
#
# Environment (mostly for tests/run; none needed in normal use):
#   BRANCH             name to check instead of the current branch
#   SITE_DIR           site to build (default: the repository root)
#   FEED_FILE          single feed to check (default: the two feeds above)
#   FEED_PUBLIC        built site the feed's item links resolve into
#                      (default: $SITE_DIR/public)
#   HUGO_VERSION       version to require (default: read from netlify.toml)
#   HUGO_CACHE         where the pinned Hugo is unpacked
#                      (default: ${TMPDIR:-/tmp}/hugo-<version>)
#   HUGO_RELEASES_URL  base URL of the release assets
#                      (default: https://github.com/gohugoio/hugo/releases/download)

set -u

top=$(cd "$(dirname "$0")/.." && pwd) || exit 1
SITE_DIR=${SITE_DIR:-$top}

# The theme is never edited and only moves on purpose. Updating it means
# moving the submodule and this pin in the same commit (see README.md).
THEME_PATH=themes/hugo-bearblog
THEME_PIN=efc24bc5e95f0ccb88051e1a7d95e8a1404e953e

say() { echo "gates: $*"; }
err() { echo "gates: $*" >&2; }

pinned_version() {
  if [ -n "${HUGO_VERSION:-}" ]; then echo "$HUGO_VERSION"; return 0; fi
  v=$(sed -n 's/^[[:space:]]*HUGO_VERSION[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' "$top/netlify.toml" | head -n 1)
  if [ -z "$v" ]; then err "no HUGO_VERSION in netlify.toml"; return 1; fi
  echo "$v"
}

# True if the hugo on PATH is the pinned version, extended edition.
hugo_matches() {
  out=$(hugo version 2>/dev/null) || return 1
  case "$out" in *"v$1-"*extended*|*"v$1+extended"*) return 0 ;; esac
  return 1
}

ensure_hugo() {
  ver=$(pinned_version) || return 1
  if hugo_matches "$ver"; then return 0; fi
  cache=${HUGO_CACHE:-${TMPDIR:-/tmp}/hugo-$ver}
  PATH="$cache:$PATH"; export PATH
  if hugo_matches "$ver"; then return 0; fi

  case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)  plat=linux-amd64 ;;
    Linux-aarch64|Linux-arm64) plat=linux-arm64 ;;
    *) err "no pinned-Hugo download for $(uname -s)-$(uname -m); install Hugo extended $ver yourself"; return 1 ;;
  esac
  base=${HUGO_RELEASES_URL:-https://github.com/gohugoio/hugo/releases/download}/v$ver
  asset=hugo_extended_${ver}_$plat.tar.gz
  sums=hugo_${ver}_checksums.txt
  say "fetching Hugo extended $ver ($plat) into $cache"

  dl=$(mktemp -d) || return 1
  if ! curl -fsSL -o "$dl/$asset" "$base/$asset" || ! curl -fsSL -o "$dl/$sums" "$base/$sums"; then
    err "could not download $base/$asset or its checksums"; rm -rf "$dl"; return 1
  fi
  want=$(awk -v f="$asset" '$2 == f { print $1 }' "$dl/$sums")
  got=$(sha256sum "$dl/$asset" | awk '{ print $1 }')
  if [ -z "$want" ] || [ "$want" != "$got" ]; then
    err "checksum mismatch for $asset (expected '${want:-none listed}', got '$got'); refusing to install"
    rm -rf "$dl"; return 1
  fi
  mkdir -p "$cache" && tar -xzf "$dl/$asset" -C "$cache" hugo || { err "could not unpack $asset"; rm -rf "$dl"; return 1; }
  rm -rf "$dl"
  if ! hugo_matches "$ver"; then err "installed Hugo does not report v$ver extended"; return 1; fi
}

gate_branch_name() {
  name=${BRANCH:-$(git -C "$top" symbolic-ref --short -q HEAD)}
  if [ -z "$name" ]; then err "detached HEAD; set BRANCH to the name you will push as"; return 1; fi
  "$top/scripts/check-branch-name" "$name"
}

gate_build() {
  ensure_hugo || return 1
  (cd "$SITE_DIR" && hugo --gc --minify --quiet)
}

gate_feed() {
  public=${FEED_PUBLIC:-$SITE_DIR/public}
  if [ -n "${FEED_FILE:-}" ]; then
    set -- "$FEED_FILE"
  else
    set -- "$public/index.xml" "$public/blog/index.xml"
  fi
  for feed in "$@"; do
    if [ ! -s "$feed" ]; then err "feed $feed is missing or empty (run the build gate first)"; return 1; fi
  done
  python3 -I - "$public" "$@" <<'EOF'
# Each feed must parse as RSS and carry full content: every item's
# <description> holds the whole rendered post (the text of the post page's
# <content> element) and no root-relative src="/ or href="/ links, which a
# feed reader would resolve against the wrong host.
import os, re, sys
import xml.etree.ElementTree as ET
from html.parser import HTMLParser
from urllib.parse import urlparse

class ContentText(HTMLParser):
    """Collects the text inside <content>...</content>."""
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.depth, self.parts = 0, []
    def handle_starttag(self, tag, attrs):
        if tag == "content": self.depth += 1
    def handle_endtag(self, tag):
        if tag == "content" and self.depth: self.depth -= 1
    def handle_data(self, data):
        if self.depth: self.parts.append(data)

def text_of(markup):
    # Text only, whitespace dropped, so minified and unminified renderings
    # of the same body compare equal.
    p = ContentText(); p.feed(markup); p.close()
    return re.sub(r"\s+", "", "".join(p.parts))

public, feeds = sys.argv[1], sys.argv[2:]
bad = []
for feed in feeds:
    try:
        root = ET.parse(feed).getroot()
    except ET.ParseError as e:
        sys.exit("gates: %s does not parse: %s" % (feed, e))
    channel = root.find("channel")
    if root.tag != "rss" or channel is None:
        sys.exit("gates: %s is not an RSS document with a <channel>" % feed)
    items = channel.findall("item")
    if not items:
        bad.append("%s: no items" % feed)
    for item in items:
        link = (item.findtext("link") or "").strip()
        desc = item.findtext("description") or ""
        where = "%s: item %s" % (feed, link or "(no link)")
        if re.search(r'(src|href)="/(?!/)', desc):
            bad.append("%s: root-relative src or href in description" % where)
        page = os.path.join(public, urlparse(link).path.lstrip("/"))
        if page.endswith("/") or os.path.isdir(page):
            page = os.path.join(page, "index.html")
        if not os.path.isfile(page):
            bad.append("%s: rendered page %s not found" % (where, page))
            continue
        with open(page, encoding="utf-8") as f:
            body = text_of(f.read())
        if not body:
            bad.append("%s: %s has no <content> text" % (where, page))
        elif body not in text_of("<content>" + desc + "</content>"):
            bad.append("%s: description is not the full post (summary only?)" % where)
if bad:
    sys.exit("gates: feed is not full-content:\n  " + "\n  ".join(bad))
EOF
}

gate_no_theme_edit() {
  link=$(git -C "$top" ls-files -s -- "$THEME_PATH" | awk '{ print $2 }')
  if [ "$link" != "$THEME_PIN" ]; then
    err "$THEME_PATH gitlink is '${link:-missing}', pinned is $THEME_PIN"; return 1
  fi
  head=$(git -C "$top/$THEME_PATH" rev-parse HEAD 2>/dev/null)
  if [ "$head" != "$THEME_PIN" ]; then
    err "$THEME_PATH is checked out at '${head:-nothing}', pinned is $THEME_PIN (git submodule update --init)"; return 1
  fi
  dirty=$(git -C "$top/$THEME_PATH" status --porcelain)
  if [ -n "$dirty" ]; then
    err "$THEME_PATH has local changes; the theme is never edited, override in layouts/ instead:"
    echo "$dirty" >&2; return 1
  fi
}

run_gate() {
  case "$1" in
    ensure-hugo)   ensure_hugo ;;
    branch-name)   gate_branch_name ;;
    build)         gate_build ;;
    feed)          gate_feed ;;
    no-theme-edit) gate_no_theme_edit ;;
    *) err "unknown gate '$1'"; return 2 ;;
  esac
}

[ "$#" -eq 0 ] && set -- branch-name build feed no-theme-edit
fail=0
for g in "$@"; do
  if run_gate "$g"; then say "$g: pass"; else say "$g: FAIL"; fail=1; fi
done
exit "$fail"
