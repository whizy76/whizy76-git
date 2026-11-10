# CLAUDE.md: how to work in this repo without colliding with the other chefs

Read this whole file before you change anything. It is public: never add server names, paths, keys,
tokens, or real browsing data to it or to anything else in this repo.

## 1. What this repo is
- **Browse History Recall** (a one-file web app, `index.html`, plus its libraries). Public, MIT, shown at
  https://whizy76.github.io/whizy76-git/ and linked from https://chisheu.com/browse-history/.
- This repo is a **public mirror** of the app as it lives on chisheu.com. It is not where releases are made.

## 2. The chefs, and who owns what
| Chef | Where it works | Owns |
|---|---|---|
| **Owner** (SuperWhizy) | everywhere | all decisions; says "push it", approves deploys |
| **Desktop Claude** | the owner's Windows PC, this repo and a clone of the private `chisheu.com` repo | prototyping, features, merges onto a branch, the public mirror |
| **VPS Claude** | the VPS, the private `chisheu.com` repo (`master`) | review, merge to `master`, deploy to the live site, CHANGELOG.md, sitemap |
| ~~Hexy~~ (former site agent) | removed 2026-11-10 | **Removed from the project.** Its old duties (cron jobs, server work, monitoring) are unassigned until the owner decides. Do not take them over, and do not assume anyone else has. Ask the owner |

The two Claudes **cannot talk to each other**. GitHub is the only shared surface, so everything that
matters must be in a commit, a branch name, or the report below. If it is not written down, it did not happen.

## 3. Source of truth and direction of travel
```
 Desktop Claude --branch--> private chisheu.com repo --VPS reviews, merges, deploys--> live site
                                      |
                                      +--(after the VPS merges to master)--> sync-from-site.sh --> THIS repo
```
- **The private `chisheu.com` repo (`browse-history/` folder, branch `master`) is the source of truth.**
- This repo is **downstream**. Never edit the app here and expect the site to pick it up.
- Real changes to the app are made as a **branch in the private repo** (`browse-history-vX.Y.Z`), pushed, and
  handed to VPS Claude. Never push to that repo's `master`. VPS Claude merges and deploys.
- Prototyping here is allowed, but it must reach the site through the three-way merge in section 5, not by
  overwriting the site's file.

## 4. What is deliberately different from the site copy
`sync-from-site.sh` handles these automatically. Do not "fix" them:
- The usage-counter line (`api.chisheu.com/metrics.js`) is **removed here**. The app's own calls to
  `chMetrics` are guarded no-ops when the script is absent. Forks and clones must never report to chisheu.com.
- `og.jpg` is not copied. `preview.jpg` in this repo is our own screenshot (fake or non-sensitive data only).
- The `canonical` and social-preview URLs still point at chisheu.com on purpose.
- This repo also holds `sync-from-site.sh`, `README.md` and this file. The site copy does not.

## 5. Procedures
**A. Sync the public mirror after the site changes** (only after VPS Claude has merged to `master`; the one
exception is a pre-release sync from a named branch commit, which must be said in the commit message)
1. In the private clone: `git fetch`, check out `master`, `git pull --ff-only`.
2. Here: `./sync-from-site.sh <path to the clone>/browse-history`
3. `git diff --stat`, update `README.md` if features changed, commit ("Sync from site vX.Y.Z (<site commit>)").
4. Tag it: `git tag site-vX.Y.Z` and push the tag. **That tag is the merge base for the next prototype.**

**B. Bring a prototype from here into the site** (three-way merge, never a straight overwrite)
1. base = this repo's `index.html` at the last `site-v*` tag; ours = the prototype; theirs = the site's current file.
2. `git merge-file -p ours.html base.html theirs.html > merged.html`, normalise line endings first (the
   site's working copy can be CRLF on Windows; the repo stores LF). Resolve conflicts keeping BOTH sides' intent.
3. Bump version in all four places: the header comment, `<title>`, the `ver` chip, and `const VERSION`. Add the
   in-file changelog entry (newest first).
4. `node --check` every inline `<script>` block. Test with fake History data, never the owner's real file.
5. Branch in the private repo, `git add` the explicit file path only, push the **branch**, hand over (section 7).

## 6. Rules that prevent most collisions
- **Check before you start:** `git fetch --all`, then look at `git log origin/master -5` in the private repo and
  `git log origin/main -5` here. If the site moved since your last sync, sync first.
- **GitHub `master` can lag the VPS.** Automated jobs and VPS Claude commit to the site's `master` on the VPS and
  push in batches. Always `git fetch` and base a new branch on the current `origin/master`, never on an old
  local copy. Sync the mirror only from a `master` you have just fetched.
- **Merge order on the VPS is deploy, then log, then merge.** A branch is merged only after it is live, so `master`
  matches the live site. `CHANGELOG.md` is VPS-owned: never edit it; on a conflict take `master`'s copy.
- **Anything under `world/` goes live the moment it is merged** (served straight from the VPS). Never put `world/`
  changes on a branch unless the owner wants them live at merge time.
- **One writer per file at a time.** Branch names say who is working: `desktop/<topic>` or
  `browse-history-vX.Y.Z` for Desktop Claude, `vps/<topic>` for VPS Claude.
- **Stage explicit paths only.** Never `git add -A` or `git commit -a` in the private repo: it has other
  people's uncommitted work in it.
- **Never** force-push, `git reset --hard`, or `git checkout <commit> -- <path>`. No exceptions without the owner.
- **Never deploy from the desktop.** Deploying is VPS Claude's job (it does a drift check first).
- **Never delete or rewrite substantive features** without the owner's yes. Adding is fine.
- Keep the app local-only: nothing from the user's History file may leave the browser. Optional features that
  fetch from the internet (thumbnails) must stay **opt-in and off by default**, with a plain disclosure.
- Version numbers: semver. Patch = fix, minor = feature. The public mirror's version must equal the site's.

## 7. Handoff message (paste to the owner, who relays it to the other chef)
```
Desktop Claude report - <date>
Task: <one line>
Branch / commit: <repo> <branch> <hash>
App / version: Browse History Recall vX.Y.Z (was vA.B.C)
Files changed: <explicit paths>
Tested: <what, with fake data?>  Console errors: none / <...>
Needs from VPS Claude: fetch, review diff, drift check, deploy <file>, logchange, merge to master
Public mirror: not yet synced / synced at site-vX.Y.Z
Open questions / things I did NOT touch: <...>
```

## 8. Known gotchas (learned the hard way)
- The browser preview pane in the desktop app runs a local file under a different base URL, so relative
  library files do not load there. Test against CDN copies of the libraries in a throwaway folder and delete it.
- `git merge-file` on files with mixed LF/CRLF produces whole-file conflicts. Normalise first.
- sql.js's `.wasm` is ignored by the private repo's `.gitignore`; it was force-added. Do not "clean it up".
- The 3D zoom handles the `wheel` event itself (non-passive, with `preventDefault`) so it can zoom toward the
  cursor. Touch pinch zoom is not supported by that custom zoom; do not claim it is.
