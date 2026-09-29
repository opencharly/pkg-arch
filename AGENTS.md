# AGENTS.md — opencharly/pkg-arch

Arch Linux packaging for the `charly` CLI. The repo owns the `opencharly-git`
`PKGBUILD` (the package is LOCAL-ONLY — not published to the AUR). The package
builds the `charly` binary + its welded command plugins from the release and
installs it system-wide.

Canonical files:

- `PKGBUILD` — the `opencharly-git` package recipe (`pkgver()` derives the CalVer
  from the HEAD commit via `calver.sh`; `depends`/`optdepends` carry every
  runtime OS dependency).
- `calver.sh` — the shared CalVer stamp (`YYYY.DDD.HHMM`, UTC) used by `pkgver()`
  and the build `ldflags`.
- `opencharly-git.install` — the pacman install hooks.
- `test-build-path.sh`, `test-depends.sh` — the repo-local gates for the
  post-cutover `build()` layout and the mandatory nerdctl engine-stack depends.
- `CHANGELOG/` — history (one file per CalVer release).
- `README.md` — user overview only; never agent guidance.

## Load these skills first (R0)

- `/charly-internals:repo-setup` — the org landing automation (required workflow,
  native auto-merge, tag-on-merge CalVer) and the new-repo checklist.
- `/charly-tools:charly` — the `charly` toolchain candy and the runtime OS
  dependencies the packages must carry.

## Build / validate / test

- `makepkg -si` — build and install the package locally (resolves the AUR-only
  deps via an AUR helper).
- `bash test-build-path.sh` — asserts the PKGBUILD uses the post-cutover layout
  (standalone plugin repos at their tags, no `opencharly-sdk` submodule source).
- `bash test-depends.sh` — asserts the nerdctl engine stack (`nerdctl`,
  `cni-plugins`, `rootlesskit`, `buildkit`) is in `depends`.
- The merge gate is the **org-wide** `charly/pr-validator` (required check
  `validate / validate`, defined in `opencharly/.github`); this repo carries no
  per-repo candy gate.

## Modify this repo

- Every runtime OS dependency `charly` invokes belongs in the `depends` array
  (or `optdepends` for the engine/AUR/GPU situational tools). A dependency added
  only to the charly candy's `packaging:` section, or only installed by hand, is
  not sufficient — the package must install cleanly on a fresh host.
- The package version mirrors `charly version`; keep the `calver.sh` derivation
  as the single source (shared with the bootstrap build).

## Landing

- PR-only. Every change lands through a pull request; the org-required
  `charly/pr-validator` validates the diff and body and arms native auto-merge on
  PASS. Direct pushes to `main` are blocked.
- History lives in `CHANGELOG/` (written by `tag-on-merge` at merge time); the PR
  body IS the changelog.
- The authoritative rulebook is the umbrella `AGENTS.md` in
  `opencharly/opencharly` and `charly/AGENTS.md` in the charly repo. Do not
  restate its rules here.
