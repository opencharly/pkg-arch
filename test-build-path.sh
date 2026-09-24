#!/usr/bin/env bash
# test-build-path.sh — the pkg-arch-LOCAL gate for the migrated build() path. The
# candy de-submodule cutover removed the in-superproject candy/ tree and the sdk
# submodule, so the pre-cutover build() (candy/<name> siblings + pkg/host-command-
# plugins.txt + the opencharly-sdk source) no longer builds. This asserts the
# PKGBUILD uses the post-cutover layout and FAILS otherwise. Run:
# `bash test-build-path.sh`.
set -euo pipefail

pkg="$(dirname "$0")/PKGBUILD"
rc=0

must() { # <label> <literal>
    if grep -qF -- "$2" "$pkg"; then
        echo "ok   $1"
    else
        echo "FAIL $1 — expected to find: $2" >&2
        rc=1
    fi
}
must_not() { # <label> <literal>
    if grep -qF -- "$2" "$pkg"; then
        echo "FAIL $1 — must NOT find: $2" >&2
        rc=1
    else
        echo "ok   $1"
    fi
}

must     "build reads the single-source list from scripts/"      'scripts/host-command-plugins.txt'
must     "build clones each plugin's standalone repo at its tag" 'git clone --quiet --depth 1 --branch'
must     "build targets the plugin's candy/<name> dir"           'candy/${p}'
must_not "the pre-cutover sdk submodule source is gone"          'opencharly-sdk::git+'
must_not "the pre-cutover in-tree candy/ plugin_root is gone"    'plugin_root="${worktree_root}/candy"'

exit "$rc"
