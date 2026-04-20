# deadstick.net — Google Play / Android audit

_Audit date: 2026-04-19. Based on Google Play Developer Program Policies,
Google Play Console requirements, and Android platform requirements as of
this date. Parallels the scope of `APPLE_AUDIT.md` — this audits **the
website**, with flagged items for things that live inside the app or inside
the Play Console._

## Legend

- ✅ **Pass** — meets Google's requirement.
- ⚠️  **Fix recommended** — works today but has a concrete gap or risk.
- 🚧 **Action required outside the website** — Chance needs to do this in
  the Play Console, in the app's Android code, or in the Google Play
  Developer account.

---

## 1. Required URLs (Play Console)

Every app's Play Console listing must declare specific URLs under
**App content → Privacy policy** and **Store settings**:

| URL type              | Requirement | deadstick.net has it                         | Status |
|-----------------------|-------------|----------------------------------------------|--------|
| Privacy Policy        | Required    | `privacy.html`                               | ✅ |
| Support URL (email)   | Required    | contact via `index.html#contact` + `support.html` | ✅ (email address is collected through the contact form; Play Console requires an actual email address field, see §9 below) |
| Marketing Website     | Optional    | `index.html` + per-app page                  | ✅ |
| Data Deletion URL     | Required (any app with user accounts or that collects personal data) | `deletion.html` | ✅ |

Google Play's **User Data policy** requires the privacy policy to be
comprehensive, accessible, and specifically describe the app's data handling.
`privacy.html` meets this, including app-specific sections in §10.

## 2. Privacy policy content (User Data policy)

Google's User Data policy requires the policy to disclose:

| Requirement                                                | Covered in `privacy.html`                                | Status |
|------------------------------------------------------------|----------------------------------------------------------|--------|
| Developer / publisher identity                             | §2 + §12                                                 | ✅ |
| Types of personal & sensitive data accessed / collected    | §3                                                       | ✅ |
| How the data is used and why                               | §4                                                       | ✅ |
| Parties the data is shared with                            | §5                                                       | ✅ |
| Secure data handling (transit + at rest)                   | §9                                                       | ✅ |
| Data retention and deletion policy                         | §6 + §7 + dedicated `deletion.html`                      | ✅ |
| Compliance with applicable laws (CCPA / GDPR / COPPA etc.) | §7 + §8                                                  | ✅ |

**App-specific sections** in §10 name each app (ClawMelt, BillingBird,
CarrierPigeonVPN) and describe what, if anything, is handled per app — which
satisfies Google's requirement that the policy be "specific to the app".

## 3. Data Safety section (🚧 Play Console filing)

Separate from the privacy policy, Google Play requires every app to complete
the **Data Safety** form in the Play Console. The answers must match the
privacy policy. Based on `privacy.html`, the answers for each app are:

| Question                                 | ClawMelt | BillingBird | CarrierPigeonVPN |
|------------------------------------------|----------|-------------|------------------|
| Does the app collect user data?          | No       | No¹         | No²              |
| Does the app share user data?            | No       | No          | No               |
| Is data encrypted in transit?            | Yes (TLS for any optional third-party download) | Yes (sync via iCloud / Google Drive) | Yes (WireGuard) |
| Can users request data deletion?         | Yes — uninstall + `deletion.html` | Yes — local DB wipe + `deletion.html` | Yes — uninstall per-device + `deletion.html` |

¹ BillingBird stores business data **locally** or in the user's own iCloud /
Google Drive account — not collected by DeadStick Digital. Google's form
treats cloud-sync through the user's own provider account as "not collected
by the app developer."

² CarrierPigeonVPN establishes a direct peer-to-peer WireGuard tunnel. No
traffic is routed through DeadStick-operated servers. The keychain-held
WireGuard keys and paired-device identifiers are user-device-local, not
collected.

## 4. VPN apps (CarrierPigeonVPN) — Android `VpnService` policy

Google's policy for apps using `android.net.VpnService` (updated November
2024, tightened April 2025) requires:

| Requirement                                                                                                  | Status |
|--------------------------------------------------------------------------------------------------------------|--------|
| App's **core functionality** is VPN (app must not use VpnService for other purposes like blocking ads in other apps, parental controls, or tracking)  | ✅ CarrierPigeonVPN's core function is network routing |
| Declared in Play Console under the **VPN** app category                                                      | 🚧 Verify in Play Console |
| **Disclosure** that the app uses VpnService, visible to users during install / first run                     | 🚧 Must be in the Android app itself (runtime prompt + onboarding screen) |
| **Foreground service** with type `FOREGROUND_SERVICE_SPECIAL_USE` (Android 14+) and category `systemExempted` or `connectedDevice`  | 🚧 Android app manifest check |
| Support **always-on VPN** and **block connections without VPN** lockdown mode                                | 🚧 Android app behaviour check |
| Privacy policy commits to not selling, sharing, or using user traffic data for advertising, marketing, or analytics purposes | ✅ `privacy.html` §10.3 covers this — the Apple 5.4 language satisfies Google's equivalent requirement |
| Not a free / commodity VPN that obscures the user's identity on the public internet | ✅ CarrierPigeonVPN doesn't offer exit nodes; the user's own phone is the exit |

## 5. Sensitive permissions & declarations

| Permission                                                                 | Apps that use it           | Play Console declaration | Status |
|----------------------------------------------------------------------------|-----------------------------|--------------------------|--------|
| `BIND_VPN_SERVICE` + `FOREGROUND_SERVICE_SPECIAL_USE` (VPN)                | CarrierPigeonVPN            | Required for VPN apps    | 🚧 app-side |
| `INTERNET`                                                                 | All three                   | No declaration needed    | ✅ |
| `CAMERA` (if BillingBird does receipt scanning)                            | BillingBird (TBD)           | In-app rationale prompt required | 🚧 app-side, clarify scope |
| `READ_MEDIA_IMAGES` / photo picker                                         | BillingBird (if users attach receipts) | Photo picker preferred on Android 13+ | 🚧 app-side |
| `POST_NOTIFICATIONS` (Android 13+)                                          | All three if they notify    | Runtime permission       | 🚧 app-side |

The website does not need to enumerate permissions — that is the Play Console
job — but the privacy policy should name any permission that accesses
personal or sensitive data. Currently none are named because none of the
apps access sensitive user data categories (SMS, call log, contacts,
location, etc.). If that ever changes, update `privacy.html` §3 to list the
new permission and its purpose.

## 6. Target API level compliance (🚧 app-side)

Google enforces a minimum target API level every year:

- As of **August 2025**, new apps must target **API level 35** (Android 15).
- As of **August 2026**, new apps must target **API level 36** (Android 16).

Existing app updates have a one-year grace period. This is an app-side
build-configuration item, not a website item.

## 7. Content rating (🚧 Play Console filing)

Every app must complete the **Content Rating questionnaire** (IARC) in the
Play Console. For these three apps, the expected rating is **Everyone** —
no user-generated content, no violence, no communication features that would
trigger a higher rating.

## 8. Account deletion (User Data policy)

Google requires apps that allow account creation to offer **in-app account
deletion** and a **web-based deletion route**. None of the three apps have
user accounts on DeadStick-operated servers, so the strict in-app
requirement does not apply, but `deletion.html` already documents the
data-deletion steps for each app and satisfies the web-based route — ✅.

If any app ever gains user accounts, both the in-app deletion flow and the
Play Console **Data deletion URL** field must be updated.

## 9. 🚧 Play-Console-side items (not a website fix)

These aren't on the website but are worth queuing up before Chance submits
anything to Play Review:

1. **Google Play Developer account.** Register DeadStick Digital LLC as an
   **organization** at <https://play.google.com/console/> ($25 one-time
   registration fee). Identity verification will require business
   documentation — the Wyoming formation certificate and EIN letter are
   the usual proof.
2. **Data Safety form.** Fill out the form for each app using the answer
   grid in §3 of this document. Must match `privacy.html` exactly.
3. **Content rating questionnaire.** Complete for each app (§7).
4. **Target SDK.** Confirm Android builds target API 35 (Android 15) or
   API 36 (Android 16) before submission (§6).
5. **VPN declarations.** For CarrierPigeonVPN, select the **VPN** app
   category, declare VpnService usage, and include in-app disclosure
   screens (§4).
6. **Contact email.** Play Console requires a specific contact email for
   each app. Use `contact@deadstick.net`.
7. **In-app privacy links.** Google's User Data policy requires the privacy
   policy to be accessible **inside the app**, not just on the Play Store
   listing. Each app's Settings / About screen must link to
   <https://www.deadstick.net/privacy.html>.
8. **Billing / payments.** Google Play distribution requires that all in-app
   digital-goods purchases use **Google Play Billing** — no third-party
   processors. (External web purchases are allowed after the 2024 FTC + EU
   rulings, but in-app purchases on Android must use Play Billing.) This
   affects:
   - **CarrierPigeonVPN** (first app to ship, confirmed 2026-04-20):
     auto-renewing US$4.99/year subscription on the phone app, with a free
     trial. The Android build must offer this through Google Play Billing as
     a subscription product, with the free trial declared in the Play Console
     subscription configuration.
   - **BillingBird** (confirmed 2026-04-20 as a subscription product): same
     rule — the Android build must offer the subscription through Google Play
     Billing, with any free trial declared in the Play Console subscription
     configuration.
   - **ClawMelt** (confirmed 2026-04-20 as a subscription product): when an
     Android build ships, same Google Play Billing rule applies. The macOS
     build will use Apple In-App Purchase on the Mac App Store.

## 10. Summary — what still to do

### Website changes (small)

- [ ] Consider adding a one-line Google-Play-parallel to privacy.html §10.3
      explicitly stating compliance with Google Play's VpnService policy.
      Optional — the Apple 5.4 language substantively covers it, but being
      explicit helps the reviewer.

### Play-Console-side setup (outside this repo)

- [ ] Register DeadStick Digital LLC as a Google Play Developer organization.
- [ ] Complete Data Safety form for each app using §3.
- [ ] Complete Content Rating questionnaire for each app.
- [ ] Target API 35 (Android 15) or API 36 (Android 16) for each Android build.
- [ ] CarrierPigeonVPN: select VPN category, declare VpnService, add in-app
      disclosure screens, support always-on VPN + lockdown.
- [ ] Add in-app links to `privacy.html` from each Android app.
- [ ] Provide `contact@deadstick.net` in Play Console app contact fields.
- [ ] CarrierPigeonVPN Android build: ship the US$4.99/year subscription
      through Google Play Billing as a subscription product, declare the free
      trial in the Play Console subscription configuration.
- [ ] BillingBird Android build: ship the subscription through Google Play
      Billing as a subscription product, declare any free trial in the Play
      Console subscription configuration.
- [ ] ClawMelt Android build (if/when shipped): same — Google Play Billing
      subscription product with free-trial declaration.
