# Agent Handoff

Last updated: 2026-07-11

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

- Active task: Reposition the BillingBird product page around customer ownership of bookkeeping
  data without changing the site design.
- Last agent: Reworked the BillingBird metadata, hero, and detail-content hierarchy so professional
  invoicing, local user-owned records, optional personal-cloud sync, and the absence of a DeadStick
  bookkeeping server are clear before the feature list. Added the phone/server/device comparison,
  plain-language data-ownership copy with current iOS/iCloud and qualified Google Drive
  availability, ownership and business capability groups, a highlighted export/no-lock-in section,
  the product rationale before Accessibility, and Technical specifications as the final content
  section. Navigation, footer, detail layout, side card, privacy link, shared CSS, and visual
  language remain unchanged.
- Files touched by this local slice:
  - `apps/billingbird.html`
  - `tests/billingbird-ownership-page.test.sh` (new focused regression gate)
  - `AGENT_HANDOFF.md`
- Verification:
  - `bash tests/billingbird-ownership-page.test.sh` passed.
  - `bash tests/privacy-billingbird.test.sh` passed.
  - `/Users/chanceneel/Projects/SuperAssistant/scripts/local-validate.sh website --standard`
    passed with 0 failures, including the local secret scan.
  - Every `tests/*.sh` file passed independently with fail-fast handling (13/13).
  - `git diff --check` passed.
  - `CNAME` remains exactly `www.deadstick.net`.
  - Local browser review passed at 1440x1100 and 390x844: the hero, comparison,
    highlighted export panel, section order, responsive layout, side card, and footer render in the
    established site design with no BillingBird-page console warnings or errors.
  - The Learn more anchor, privacy-policy link, and contact-support link were exercised locally and
    reached their intended destinations.
- Publication state: committed to and pushed on `main` after explicit owner approval. GitHub Pages
  built commit `e9ed81a`, and the live BillingBird page, stylesheet, and app icon returned HTTP 200.
  The production page contains the ownership-first hero and required ownership, export, rationale,
  accessibility, and technical-specification headings. No blockers remain.

- Active task: DeadStick Utilities app page (assurance-focused) in the standard app-page format.
- Last agent: Built `apps/deadstick-utilities.html` in the same structure as the other app pages
  (app-hero, detail grid, security-measures panel, side card), centered on the sanctioned claim
  "designed to meet or exceed applicable government-grade software assurance practices" with an
  explicit no-certification disclaimer in the assurance panel and footer legal note. Added the
  app to the homepage as a full-width coming-soon feature card (grid-column 1/-1), updated the
  apps heading to "Five apps. One philosophy.", meta/og descriptions, and footer Apps list.
  Added `icons/deadstick-utilities.png` (1024px). Note: the Utilities repo brand exports have a
  transparency checkerboard baked into the pixels with margins around the artwork; the website
  icon was regenerated by cropping to the artwork bounds (863px square at +81+88) and applying a
  true rounded-rect alpha mask so it renders full-bleed with transparent corners. The source
  assets in the Utilities repo (brand PNG and both AppIcon asset catalogs) still need the same
  fix before App Store submission. Also added new
  `--deadstick-utilities` steel-silver accent variables, app-card and security-measures CSS
  variants, and bumped the homepage stylesheet cache-bust to `?v=20260704-deadstick-utilities`
  (with the matching pin update in `tests/homepage-app-focus.test.sh`). Added
  `tests/deadstick-utilities-app-page.test.sh` enforcing the sanctioned assurance phrasing,
  certification disclaimers, honest iOS-limits copy, and homepage card wiring.
- Verification: `local-validate.sh website --standard` passes with 0 failures; every
  `tests/*.sh` file also passes when run individually (note: the shared runner's `for` loop
  masks mid-loop test failures — only the last test's exit code propagates; worth fixing in
  SuperAssistant). Both pages visually verified in a local browser at 1440px (screenshots
  reviewed; hCaptcha logs a localhost warning in local preview only).
- Update (2026-07-04, latest): replaced the homepage apps grid with an equal-size horizontal
  snap rail (`grid-auto-flow: column; grid-auto-columns: 344px`, snap points, thin scrollbar,
  vertical stack under 700px) because the full-width DeadStick Utilities card broke the grid
  rhythm. All five cards now share one footprint and the rail scales to future apps. Owner
  wording directive enforced across the app page: every NIAP/FIPS reference uses the
  "designed to meet" formula (never "meets"), pinned by the page shell test. Commits ac31c9b,
  872409b, e1ffc26 pushed and verified live.
- Update (2026-07-04, later): rewrote `apps/deadstick-utilities.html` in plain, positive
  language at owner request, with NIAP and FIPS named explicitly. NIAP is described accurately
  as the NSA-operated National Information Assurance Partnership and its Protection Profile for
  Application Software; FIPS 140-3 is described as the federal cryptography standard met via
  Apple platform corecrypto (no custom cryptography). Claim ceilings from the Utilities repo
  assurance docs are preserved (designed-to-meet-or-exceed phrasing; explicit
  no-certification/no-validation disclaimers in the assurance panel and footer), and the page
  shell test now pins the NIAP/FIPS literals. Committed as ac31c9b, pushed, and verified live.
- Status: committed as 88f7c4e and pushed to origin/main on 2026-07-04 after owner approval
  ("update the website to now have a section for DeadStick Utilities"). Live verification after
  GitHub Pages deploy: homepage shows the card and "Five apps. One philosophy.", the app page and
  icon return 200, the sanctioned assurance phrasing is present on the live page, and the
  Apple-required URLs (/deadstick-utilities/, /privacy/, /terms/, /support/) all return 200. The
  Utilities repo validators `validate_legal_support_url_readiness.sh --verify` and
  `validate_subscription_disclosure.sh --verify` pass against this working copy.
- Files touched by this slice:
  - `apps/deadstick-utilities.html` (new)
  - `icons/deadstick-utilities.png` (new)
  - `tests/deadstick-utilities-app-page.test.sh` (new)
  - `index.html`
  - `styles.css`
  - `tests/homepage-app-focus.test.sh`
  - `AGENT_HANDOFF.md`

## Previous Handoff (2026-06-28)

- Active task: Prepare Holos Document Vault public legal/support URLs for the paid-release public
  URL gate.
- Last agent: Published the Holos public URL pages to GitHub and verified the live production
  URLs after GitHub Pages deployment.
- Summary: Added pages for the eight required Holos production endpoints:
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
  - GitHub Pages `pages-build-deployment` succeeded for commit `a660df7`.
  - Holos live public URL checker passed: all eight production URLs returned HTTP 200.
- Release state: committed as `d1ffac5` (`publish Holos public URL pages`) plus handoff commit
  `a660df7` and pushed to `origin/main` on June 28, 2026. GitHub Pages deployed successfully.
- Next steps: use the now-live URLs in App Store/paid-release evidence, then continue the Holos
  blocker list for physical-device QA, Supabase configuration, and final paid-submission evidence.
- Blockers: no website blocker remains.

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
