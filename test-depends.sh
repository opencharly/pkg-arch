#!/usr/bin/env bash
# test-depends.sh — the pkg-arch-local gate for the PKGBUILD depends. It FAILS if
# the nerdctl engine stack (nerdctl + cni-plugins + rootlesskit + buildkit) is
# missing from the PKGBUILD's `depends` array. Run: `bash test-depends.sh`.
set -euo pipefail

pkgbuild="$(dirname "$0")/PKGBUILD"
rc=0
for p in nerdctl cni-plugins rootlesskit buildkit; do
    if grep -qE "^\s*'${p}'" "$pkgbuild"; then
        echo "ok   depends: ${p}"
    else
        echo "FAIL depends: ${p} missing from PKGBUILD" >&2
        rc=1
    fi
done
exit "$rc"
