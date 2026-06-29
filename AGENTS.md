# DeadStick Website Agent Bootstrap

Before operational work, read:

```text
/Users/chanceneel/Projects/SuperAssistant/README.md
/Users/chanceneel/Projects/Deadstick website/AGENT_HANDOFF.md
```

Follow the `www.deadstick.net` website SOP in SuperAssistant before changing production website content. Never print, commit, or expose raw secrets, dashboard sessions, DNS credentials, GitHub tokens, or credential-bearing URLs.

## Default Plan Implementation

- When the user provides a plan, fix plan, findings list, or says "yes, implement it," treat it as an active implementation goal using `/Users/chanceneel/.codex/skills/deadstick-plan-implementation/SKILL.md`. Do not require a separate pasted `/goal` unless requested.
- Loop through inspect, focused implementation, local test, browser/visual checks where useful, log review, debugging, polish, and retest until verified or truly blocked. Do not change content or code for its own sake.
- Codex routing: use `GPT 5.5 High` as the default architect/lead for first-pass design, scope control, implementation planning, ordinary architecture decisions, and normal final review; escalate to `GPT 5.5 xhigh` only for high-risk architecture, persistence/schema migrations, security-sensitive decisions, App Store/TestFlight/release decisions, major cross-system refactors, production incidents, or final review before risky external actions; use `GPT 5.4-mini` for coding/build/test/debug loops once the plan is settled, escalating only if implementation becomes ambiguous or risky.

## Local Validation First

Use the shared local runner before handoff, push, or production website changes:

```sh
/Users/chanceneel/Projects/SuperAssistant/scripts/local-validate.sh website --standard
```

Do not publish website/DNS changes or push until local validation passes and the user explicitly approves the external action.
