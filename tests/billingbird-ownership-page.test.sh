#!/usr/bin/env bash
set -euo pipefail

PAGE="apps/billingbird.html"

[ -f "$PAGE" ] || { echo "Missing $PAGE" >&2; exit 1; }

require() {
  local pattern="$1"
  local message="$2"

  if ! grep -qF "$pattern" "$PAGE"; then
    printf 'Missing expected BillingBird page state: %s\n' "$message" >&2
    exit 1
  fi
}

reject() {
  local pattern="$1"
  local message="$2"

  if grep -qF "$pattern" "$PAGE"; then
    printf 'Outdated or unsupported BillingBird copy remains: %s\n' "$message" >&2
    exit 1
  fi
}

line_number() {
  grep -nF "$1" "$PAGE" | head -n 1 | cut -d: -f1
}

require '<link rel="canonical" href="https://www.deadstick.net/apps/billingbird.html">' 'canonical URL should identify the public product page'
require '<link rel="stylesheet" href="../styles.css?v=20260807-bb-lineup-final">' 'product page should cache-bust its scoped BillingBird styling'
reject 'bb-finish-picker' 'the retired finish picker must not return; the lineup mix is the permanent look'
require 'class="bb-hero-icon"' 'hero should show the BillingBird feather app icon'
require '<dialog class="bb-lightbox"' 'gallery should provide the screenshot lightbox dialog'
require 'assets/billingbird/home.webp?v=20260806-even-gallery' 'gallery images should bypass stale CDN copies for publication'
require '<title>BillingBird for iPhone — Invoicing for Contractors | DeadStick</title>' 'title should name iPhone contractor positioning'
require 'content="Professional invoicing for contractors and service pros. Polished invoices, receipt capture, payments, and client balances — records stay on your iPhone."' 'meta description should match the approved iPhone-local copy'
require '<meta property="og:title" content="BillingBird for iPhone — Invoicing for Contractors | DeadStick">' 'Open Graph title should match the approved title'
require '<meta property="og:image" content="https://www.deadstick.net/assets/billingbird/og-1200x630.png">' 'Open Graph image should use the local 1200x630 asset'
require '<meta name="twitter:card" content="summary_large_image">' 'Twitter card should be large image'
require '<meta name="twitter:image" content="https://www.deadstick.net/assets/billingbird/og-1200x630.png">' 'Twitter image should match the OG asset'
require '"@type": "SoftwareApplication"' 'structured data should identify a software application'
require '"operatingSystem": "iOS 17 or later"' 'structured data should name only the current iPhone OS floor'
require 'BillingBird · Available now for iPhone' 'hero eyebrow should identify iPhone availability'
require 'Professional invoices. Know what you’re owed.' 'hero should use the approved outcome headline'
require 'BillingBird is modern, professional invoicing for contractors and service pros. Create polished invoices, capture receipts, record payments, and keep every client balance clear — all from your iPhone.' 'hero should use the approved lead paragraph'
require 'Privacy-first by design — your records stay on your iPhone, with optional private iCloud backup.' 'hero should state privacy-first device-local records'
require 'Available on the iOS App Store' 'App Store availability status should be present'
require 'https://apps.apple.com/us/app/billingbird/id6776299735' 'page should link the live App Store listing'
require '<meta name="apple-itunes-app" content="app-id=6776299735">' 'Smart App Banner should point at the live App Store listing'
require 'href="#billingbird-gallery">See BillingBird in action' 'primary hero action should reach the gallery'
require 'id="billingbird-gallery"' 'gallery anchor should exist'
require 'See what’s billed, due, and overdue.' 'gallery caption 1'
require 'Create a polished invoice in minutes.' 'gallery caption 2'
require 'Keep balances and payment history current.' 'gallery caption 3'
require 'Scan receipts and attach them to invoices.' 'gallery caption 4'
require 'Keep every client and job organized.' 'gallery caption 5'
require 'assets/billingbird/home.webp' 'gallery should expose WebP sources'
require 'assets/billingbird/home.png' 'gallery should expose PNG fallback'
require 'class="bb-gallery-stage bb-phone-' 'gallery should wrap each screenshot in an equal media stage with a lineup finish'
require 'class="bb-gallery-index"' 'gallery should show consistent sequence numbering'
require 'aria-hidden="true">03</span>' 'third gallery stage should remain numbered 03'
require 'width="780"
            height="1696"' 'gallery images must use one consistent full-screen size'
require 'alt="BillingBird home screen on iPhone showing a Good evening greeting, billing totals, and fictional recent invoices"' 'lead screenshot alt text must match the current synthetic-data screen'
require 'fetchpriority="high"' 'lead screenshot should use high fetch priority'
require 'loading="eager"' 'lead screenshot should load eagerly'
require 'loading="lazy"' 'non-lead gallery images should lazy-load'
require '<h3>Create professional invoices in minutes</h3>' 'benefit heading 1'
require '<h3>Stay on top of balances, payments, and receipts</h3>' 'benefit heading 2'
require '<h3>Keep your working records under your control</h3>' 'benefit heading 3'
require 'A simple contractor workflow' 'workflow section should be present'
require 'Your books stay yours' 'trust block should be present'
require '<strong>iPhone</strong> Available now' 'roadmap should mark iPhone as available now'
require 'designed to meet applicable government security standards' 'privacy-first assurance claim should use the sanctioned designed-to-meet formula'
require 'NIAP Protection Profile for Application Software' 'assurance claim should name the NIAP Protection Profile'
require 'FIPS 140-3' 'assurance claim should name FIPS 140-3'
require 'no government certification is claimed' 'assurance claim must keep the no-certification disclaimer'
require '<strong>iPadOS</strong> Planned' 'roadmap should include planned iPadOS'
require '<strong>macOS</strong> Planned' 'roadmap should include planned macOS'
require '<strong>Android</strong> Planned' 'roadmap should include planned Android'
require '<strong>Windows</strong> Planned' 'roadmap should include planned Windows'
require 'iPadOS, macOS, Android, and Windows support is planned.' 'roadmap wording should be explicit'
require 'The launch version lets you record manual payments. Online payment collection is planned for a later release.' 'payment clarification must be exact'
require 'Do I need a BillingBird account?' 'FAQ should cover accounts'
require 'Does BillingBird work offline?' 'FAQ should cover offline use'
require 'Where is my data stored? What about iCloud?' 'FAQ should cover storage and iCloud'
require 'Can I export my records?' 'FAQ should cover exports'
require 'How do payments work at launch?' 'FAQ should cover payments'
require 'Which platforms are supported?' 'FAQ should cover platforms'
require 'RevenueCat may provide subscription entitlement' 'subscription infrastructure should remain disclosed'
require 'href="../support.html">Support</a>' 'support should remain available in the footer'

hero_line="$(line_number 'bb-outcome-hero')"
gallery_line="$(line_number 'id="billingbird-gallery"')"
benefits_line="$(line_number 'Create professional invoices in minutes')"
workflow_line="$(line_number 'A simple contractor workflow')"
trust_line="$(line_number 'Your books stay yours')"
roadmap_line="$(line_number 'Platform roadmap')"
faq_line="$(line_number 'id="faq"')"

if ! (( hero_line < gallery_line &&
        gallery_line < benefits_line &&
        benefits_line < workflow_line &&
        workflow_line < trust_line &&
        trust_line < roadmap_line &&
        roadmap_line < faq_line )); then
  echo 'BillingBird hero, gallery, benefits, workflow, trust, roadmap, and FAQ sections are out of order.' >&2
  exit 1
fi

reject 'for Apple devices' 'Apple-devices umbrella positioning must be removed'
reject 'Built for iPhone, iPad &amp; Mac' 'multi-Apple current claim must be removed'
reject 'Private invoicing for Apple devices' 'retired Apple-devices eyebrow must be removed'
reject 'iOS 17 or later; iPadOS 17 or later; macOS 14 or later' 'structured data must not list planned Apple OS floors as current'
reject 'iPadOS 17 or later' 'current product metadata must not claim shipping iPadOS'
reject 'macOS 14 or later' 'current product metadata must not claim shipping macOS'
reject 'Most invoicing apps' 'unsupported competitor generalizations must be removed'
reject 'no lock-in' 'absolute portability language must be removed'
reject 'You stay in control. Always.' 'absolute control language must be removed'
reject 'TalkBack' 'TalkBack should not appear on the current BillingBird page'
reject 'Google Drive' 'Google Drive should not appear on the current BillingBird page'
reject 'React Native 0.76' 'stale framework versions should not remain in marketing copy'
reject 'Expo SDK 52' 'stale framework versions should not remain in marketing copy'
reject 'six themes' 'retired theme count should not remain'
reject 'Coming soon to the App Store' 'retired prelaunch status must not remain now that BillingBird is live'
reject 'estimat' 'estimates are not a BillingBird feature and must not be claimed'
reject 'NIAP-certified' 'assurance copy must never claim NIAP certification'
reject 'FIPS-certified' 'assurance copy must never claim FIPS certification'
reject 'meets NIAP' 'assurance copy must use designed-to-meet, never meets'
reject 'meets FIPS' 'assurance copy must use designed-to-meet, never meets'
reject 'Good morning, there' 'retired personalized greeting must not appear in website copy or image descriptions'

# Android/Windows must appear as planned roadmap, not as current shipping claims.
if ! grep -qF 'Android' "$PAGE" || ! grep -qF 'Windows' "$PAGE"; then
  echo 'BillingBird page is missing Android/Windows roadmap wording.' >&2
  exit 1
fi

for asset in \
  assets/billingbird/home.png \
  assets/billingbird/home.webp \
  assets/billingbird/invoice-create.png \
  assets/billingbird/invoice-create.webp \
  assets/billingbird/invoice-detail.png \
  assets/billingbird/invoice-detail.webp \
  assets/billingbird/receipt-capture.png \
  assets/billingbird/receipt-capture.webp \
  assets/billingbird/clients.png \
  assets/billingbird/clients.webp \
  assets/billingbird/og-1200x630.png
do
  [ -f "$asset" ] || { printf 'Missing BillingBird asset: %s\n' "$asset" >&2; exit 1; }
done

for asset in \
  assets/billingbird/home.png \
  assets/billingbird/home.webp \
  assets/billingbird/invoice-create.png \
  assets/billingbird/invoice-create.webp \
  assets/billingbird/invoice-detail.png \
  assets/billingbird/invoice-detail.webp \
  assets/billingbird/receipt-capture.png \
  assets/billingbird/receipt-capture.webp \
  assets/billingbird/clients.png \
  assets/billingbird/clients.webp
do
  dimensions="$(sips -g pixelWidth -g pixelHeight "$asset" 2>/dev/null | awk '/pixelWidth|pixelHeight/ {print $2}' | tr '\n' 'x' | sed 's/x$//')"
  [ "$dimensions" = '780x1696' ] || {
    printf 'BillingBird gallery asset must be 780x1696: %s is %s\n' "$asset" "$dimensions" >&2
    exit 1
  }
done

STYLES="styles.css"
[ -f "$STYLES" ] || { echo "Missing $STYLES" >&2; exit 1; }

require_css() {
  local pattern="$1"
  local message="$2"

  if ! grep -qF "$pattern" "$STYLES"; then
    printf 'Missing expected BillingBird gallery style: %s\n' "$message" >&2
    exit 1
  fi
}

reject_css() {
  local pattern="$1"
  local message="$2"

  if grep -qF "$pattern" "$STYLES"; then
    printf 'Outdated BillingBird gallery style remains: %s\n' "$message" >&2
    exit 1
  fi
}

require_css 'aspect-ratio: 1 / 2.1227;' 'gallery stages must share the equal bezel-adjusted phone aspect ratio'
require_css '#f2762a' 'the Cosmic Orange bezel default must remain'
require 'bb-phone-deep-blue' 'gallery phone 1 should wear the Deep Blue finish'
require 'bb-phone-silver' 'gallery phone 2 should wear the Silver finish'
require 'bb-phone-sage' 'gallery phone 3 should wear the Sage finish'
require 'bb-phone-lavender' 'gallery phone 4 should wear the Lavender finish'
require 'bb-phone-mist-blue' 'gallery phone 5 should wear the Mist Blue finish'
require_css 'bill: #66e0b0' 'BillingBird accent must match the mint-green app icon'
reject_css '#5ea8e8' 'retired sky-blue BillingBird accent must not return'
require_css 'object-fit: contain;' 'gallery images must fit without stretch or crop'
require_css 'scroll-margin-top: 92px;' 'gallery anchor must clear the sticky site navigation'
require_css 'scroll-snap-type: x mandatory;' 'mobile gallery must retain mandatory snap scrolling'
require_css '@media (prefers-reduced-motion: reduce)' 'gallery should respect reduced motion preferences'
reject_css '.bb-gallery-item:nth-child(even)' 'desktop alternating vertical stagger must be removed'
reject_css 'translateY(18px)' 'desktop gallery stagger offset must not return'
reject_css '.bb-gallery-item.is-detail' 'gallery must not special-case a short detail capture'

stage_count="$(grep -cF 'class="bb-gallery-stage bb-phone-' "$PAGE" || true)"
if [ "$stage_count" -ne 5 ]; then
  printf 'Expected 5 equal gallery stages, found %s\n' "$stage_count" >&2
  exit 1
fi

zoom_count="$(grep -cF 'class="bb-gallery-zoom"' "$PAGE" || true)"
if [ "$zoom_count" -ne 5 ]; then
  printf 'Expected 5 gallery zoom buttons, found %s\n' "$zoom_count" >&2
  exit 1
fi

echo "BillingBird ownership and positioning page checks passed."
