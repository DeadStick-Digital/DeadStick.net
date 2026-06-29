# Agent Handoff

Last updated: 2026-06-28

Local project: `/Users/chanceneel/Projects/Deadstick website`
Current branch snapshot: `main`
Dirty snapshot before this file: 0 changed/untracked paths

GitHub remotes:

- `origin`: `https://github.com/DeadStick-Digital/DeadStick.net.git`

GitHub push readiness snapshot:

- Antigravity MCP token check: GitHub API reported `push=true` and `admin=true` for `DeadStick-Digital/DeadStick.net`.
- Shell auth check: global `gh` default token was invalid on 2026-06-15. Run `gh auth status` before push.

## Start Here

1. Read `/Users/chanceneel/Projects/SuperAssistant/README.md`.
2. Follow the `www.deadstick.net` website SOP in that README before changing production website content.
3. Run `git status -sb` and treat it as current truth.
4. Preserve unrelated local changes.
5. Before push, handoff, or production website work, use `/Users/chanceneel/Projects/SuperAssistant/scripts/local-validate.sh website --standard` unless the user explicitly asks for a different validation mode.
6. Continue from `Current Handoff` below.
7. When the user provides or approves a plan, use `/Users/chanceneel/.codex/skills/deadstick-plan-implementation/SKILL.md` and treat it as an active implementation goal without requiring a pasted `/goal`.

## Handoff Rules

- Update this file before switching between Codex and Antigravity.
- Record active branch, summary, files touched, verification commands, known failures, and whether work is local-only, committed, pushed, or PR-backed.
- Do not store raw secrets, tokens, private keys, cookies, dashboard sessions, or credential-bearing URLs here.
- For GitHub pushes, remember that GitHub password auth is not valid for HTTPS Git operations. Use browser OAuth, SSH, or a PAT with repo/Contents write access.
- For website changes, run the local shell tests and verify `CNAME` still contains `www.deadstick.net`.

## Model Routing

- Antigravity architect: `Gemini 3.1 Pro` for production website, release, security, DNS, GitHub Pages, or cross-service decisions.
- Antigravity complex coder: `Gemini 3.5 Flash High` for multi-file content/build/test changes.
- Antigravity normal coder: `Gemini 3.5 Flash Medium` for scoped content, tests, docs, and routine debugging.
- Antigravity runner: `Gemini 3.5 Flash Low` for inspection, formatting, command interpretation, and low-risk edits.
- Codex routing: use `GPT 5.5 High` as the default architect/lead for first-pass design, scope control, implementation planning, ordinary architecture decisions, and normal final review; escalate to `GPT 5.5 xhigh` only for high-risk architecture, persistence/schema migrations, security-sensitive decisions, App Store/TestFlight/release decisions, major cross-system refactors, production incidents, or final review before risky external actions; use `GPT 5.4-mini` for coding/build/test/debug loops once the plan is settled, escalating only if implementation becomes ambiguous or risky.

## Current Handoff

- Active task: Prepare Holos Document Vault public legal/support URLs for the paid-release public
  URL gate.
- Last agent: Prepared the Holos public URL pages locally only; no push, GitHub Pages
  publication, DNS change, or external website mutation was performed.
- Summary: Added local pages for the eight required Holos production endpoints:
  `/holos/privacy/`, `/holos/terms/`, `/holos/support/`, `/holos/data-deletion/`,
  `/holos/forgotten-pin/`, `/holos/sync-recovery/`, `/holos/evidence-retention/`, and
  `/holos/incident-support/`. Updated the Holos product page links to point at the local Holos
  support and privacy pages. Added a shell test that verifies those pages exist, include
  Holos/DeadStick identity, carry endpoint-specific release-topic wording, and are linked from the
  app page where appropriate.
- Files touched by this slice:
  - `apps/holos-document-vault.html`
  - `holos/privacy/index.html`
  - `holos/terms/index.html`
  - `holos/support/index.html`
  - `holos/data-deletion/index.html`
  - `holos/forgotten-pin/index.html`
  - `holos/sync-recovery/index.html`
  - `holos/evidence-retention/index.html`
  - `holos/incident-support/index.html`
  - `tests/holos-public-urls.test.sh`
- Verification:
  - All local website shell tests passed.
  - `/Users/chanceneel/Projects/SuperAssistant/scripts/local-validate.sh website --standard`
    passed with 0 failures.
  - `CNAME` remains `www.deadstick.net`.
  - `git diff --check -- .` passed.
- Release state: committed as `d1ffac5` (`publish Holos public URL pages`) and pushed to
  `origin/main` on June 28, 2026. GitHub Pages deployment for that commit was queued immediately
  after push; the Holos public URLs should be verified live after the Pages build completes.
- Next steps: wait for GitHub Pages success, verify the eight live URLs, then rerun the Holos
  public URL checker and release blocker refresh.
- Blockers: no local website blocker remains; live URL verification depends on GitHub Pages
  publication completing.

- Active task: Publish DeadStick Utilities legal/support pages to www.deadstick.net.
- Last agent: Published DeadStick Utilities candidate pages (Privacy Policy, Terms of Use, Support, and product overview) to production via direct push to main.
- Summary: Committed and pushed the deadstick-utilities/ subdirectory (4 pages), styles.css additions for the DU console treatment, and the associated test file. All 10 local shell tests passed. CNAME confirmed as `www.deadstick.net`. `gh` auth valid (chanceneel, repo scope).
- Files touched by this slice:
  - `deadstick-utilities/index.html`
  - `deadstick-utilities/privacy/index.html`
  - `deadstick-utilities/terms/index.html`
  - `deadstick-utilities/support/index.html`
  - `styles.css`
  - `tests/deadstick-utilities-legal-support.test.sh`
  - `AGENT_HANDOFF.md`
- Verification:
  - All 10 local shell tests passed (including `deadstick-utilities-legal-support.test.sh`).
  - `CNAME` contains `www.deadstick.net`.
  - `gh auth status` reported valid token with `repo` scope.
  - GitHub Pages build: **success** for commit `72cd36a` (`pages-build-deployment`).
  - Live URL verification:
    - `https://www.deadstick.net/deadstick-utilities/privacy` — ✅ live, serves Privacy Policy with local-first posture and platform limits
    - `https://www.deadstick.net/deadstick-utilities/terms` — ✅ live, serves Terms of Use with $9.99/year Pro and subscription language
    - `https://www.deadstick.net/deadstick-utilities/support` — ✅ live, serves Support page with DeadStick Digital message form
- Pre-existing dirty state preserved (unchanged from previous slice): `icons/carrierpigeonvpn.svg` deletion, `AGENTS.md` untracked.
- Release state: committed and pushed to `origin/main` on `https://github.com/DeadStick-Digital/DeadStick.net.git`.
- Next steps: verify live URLs at /deadstick-utilities/privacy, /deadstick-utilities/terms, /deadstick-utilities/support; update App Store Connect metadata with published URLs; owner/legal review.
- Blockers: none for publication; App Store Connect metadata entry remains pending.
