# Harbr Product Roadmap & Prioritized Improvements

> Generated from 10-agent deep analysis on 2026-03-10. Covers features, UX, performance, accessibility, monetization, competitive positioning, and launch strategy.

---

## PR #1 Review Decisions

### Address (Valid)
- [x] Progress bar test asserts `height == 4.0` but default is `6.0`
- [x] Hardcoded `Color(0xF21E1830)` in pill_nav_bar → tokenize
- [x] `withOpacity` introduced in settings route → `withValues(alpha:)`
- [x] `FONT_WEIGHT_BOLD` at w500 is misleading → rename
- [x] Calendar week nav is decorative → wire to filter data

### Push Back (Figma Verified)
- Accent orange `#F97316` — Figma `theme.css: --primary: #f97316`
- Canvas `#1A1525` — Figma `theme.css: --harbr-bg: #1a1525`
- Missing = orange — Figma `StatusBadge.tsx: missing → harbr-orange`
- Transparent borders — Figma `theme.css: --harbr-border: rgba(255,255,255,0.08)`

### Discuss
- Drawer removal: Library tab cards navigate to modules, but could add back a hamburger for discoverability
- Font size increase risk: Monitor for layout breakage in legacy screens
- Settings 2px spacing: Could compromise at 4px

---

## Tier 1: Critical / High Impact

| # | Item | Category | Status |
|---|------|----------|--------|
| 1 | Onboarding/setup wizard (10 taps to first service) | UX | TODO |
| 2 | Unraid Dashboard — CPU/RAM/disk/temps | Feature | TODO |
| 3 | Docker container management — start/stop/restart/logs | Feature | TODO |
| 4 | Fix PR test bug (progress bar height assertion) | Bug | TODO |
| 5 | Lazy-initialize module states (all 10 created at startup) | Performance | TODO |
| 6 | Cancel in-flight requests on state reset | Performance | TODO |
| 7 | Parallelize dashboard calendar fetching (currently sequential) | Performance | TODO |
| 8 | Localize new screens (100+ hardcoded English strings) | i18n | TODO |
| 9 | Add Semantics to all interactive elements | a11y | TODO |
| 10 | Increase tap targets to 48x48dp minimum | a11y | TODO |

## Tier 2: High Value / Moderate Effort

| # | Item | Category | Status |
|---|------|----------|--------|
| 11 | Overseerr/Jellyseerr module (already stubbed) | Feature | TODO |
| 12 | Prowlarr module (most requested) | Feature | TODO |
| 13 | Unified global search across all services | UX | TODO |
| 14 | Activity feed / timeline ("what happened while away") | Feature | TODO |
| 15 | iOS/Android home screen widgets | Feature | TODO |
| 16 | Push notification infrastructure (Firebase SDK) | Feature | TODO |
| 17 | Notification settings page with webhook URLs | UX | TODO |
| 18 | Pull-to-refresh on Home page | UX | TODO |
| 19 | Disk SMART monitoring + alerts | Feature | TODO |
| 20 | Fix OPACITY_DISABLED mismatch (legacy 0.50 vs tokens 0.38) | Consistency | TODO |

## Tier 3: Medium Value / Build Completeness

| # | Item | Category | Status |
|---|------|----------|--------|
| 21 | Torrent client support (qBittorrent/Transmission, non-iOS) | Feature | TODO |
| 22 | Bazarr subtitle management | Feature | TODO |
| 23 | Batch operations in Library (multi-select, bulk edit) | UX | TODO |
| 24 | Grid/list view toggle for catalogue | UX | TODO |
| 25 | Server health bar on dashboard | UX | TODO |
| 26 | Enhanced download progress cards (sparklines, animation) | UX | TODO |
| 27 | Drag-to-reorder queue priorities | UX | TODO |
| 28 | In-app notification center/inbox | Feature | TODO |
| 29 | Quality upgrade assistant (find below-cutoff, batch upgrade) | Feature | TODO |
| 30 | Migrate HarbrBlock → HarbrSurface (16+ legacy tiles) | Consistency | TODO |

## Tier 4: Polish / Long-term

| # | Item | Category | Status |
|---|------|----------|--------|
| 31 | Harbr Agent (server-side plugin for unified API) | Platform | TODO |
| 32 | Storage space predictions ("run out in X months") | Feature | TODO |
| 33 | Community quality profiles (import TRaSH Guides) | Feature | TODO |
| 34 | Plex/Jellyfin direct integration | Feature | TODO |
| 35 | Shareable media lists | Social | TODO |
| 36 | Calendar device integration (Apple/Google Calendar export) | UX | TODO |
| 37 | Haptic feedback system | Polish | TODO |
| 38 | Migrate all 19 module nav bars from GNav → PillNavBar | Consistency | TODO |
| 39 | Encrypt Hive boxes (API keys in plaintext) | Security | TODO |
| 40 | Reduce image cache (128MB aggressive for mobile) | Performance | TODO |

---

## Monetization Strategy

| # | Action | Timeline |
|---|--------|----------|
| M1 | Rename "Ultra Supporter" → "Harbr Pro" | Immediate |
| M2 | Three tiers: Free (2 services) / Pro ($3.99/mo, $29.99/yr) / Lifetime ($79.99) | Launch |
| M3 | Gate: unlimited services, profiles, cloud backup, push notifications behind Pro | Launch |
| M4 | Widgets as Pro feature | Month 2-3 |
| M5 | Advanced analytics as Ultra feature | Month 4-6 |
| M6 | Publish web build as Docker on Unraid Community Apps | Month 1 |

---

## Competitive Positioning

**Identity**: "The Complete Media Command Center" — not just an *arr manager, but the first app purpose-built for the Unraid ecosystem.

**Three pillars**:
1. **Completeness** — match nzb360's breadth (add Prowlarr, Bazarr, torrent clients)
2. **Design excellence** — approach Ruddarr's quality in Flutter
3. **Cross-platform advantage** — the only app on iOS + Android + Mac + Windows + Linux + Web

**Key differentiators vs competitors**:
- vs LunaSea: Actively maintained, Readarr support, modern Material 3 design
- vs nzb360: Cross-platform (not Android-only), modern UI
- vs Ruddarr: All services (not just Radarr/Sonarr), Android + desktop support
- vs Unraid app: Media-specific features (*arr management, downloads, calendar)

---

## Launch Plan Summary

- **Pre-launch (6 weeks)**: Beta on TestFlight/Play Store, seed r/unraid + r/selfhosted, landing page, press kit, influencer outreach
- **Launch day**: Simultaneous release on all platforms, Reddit announcements, YouTube demo, Discord public
- **Post-launch (90 days)**: Weekly beta releases, bi-weekly stable, ship Overseerr module, responsive tablet layout
- **Year 1 targets**: 50K downloads, 10K MAU, 4.7+ App Store rating, 15+ services

---

## Performance Issues to Fix

| Issue | Location | Impact |
|-------|----------|--------|
| All 10 module states initialized at startup | `system/state.dart:31-40` | Memory + unnecessary API calls |
| Dashboard creates 3 redundant Dio clients | `dashboard/core/api/api.dart` | Extra memory |
| No request cancellation on state reset | RadarrState, SonarrState, TautulliState | Wasted bandwidth |
| Sequential calendar API calls | `dashboard/core/api/api.dart:22-36` | 3x slower loading |
| Excessive notifyListeners() in TautulliState | `tautulli/core/state.dart` | 5x redundant rebuilds |
| context.watch defeating Selector | `radarr/catalogue/route.dart:106-108` | Full list rebuilds |
| 128MB in-memory image cache | `image_cache_io.dart:32-33` | Memory pressure |
| Hive clear() iterates keys individually | `database/box.dart:59` | O(n) instead of O(1) |

---

## Accessibility Gaps

| Issue | Severity |
|-------|----------|
| Zero `Semantics` widgets in new screens | Critical |
| 11+ tap targets below 48x48dp | Critical |
| `onSurfaceDim` on `surface0` contrast fails WCAG AA (~3.7:1) | High |
| `onSurfaceFaint` contrast fails all standards (~2.0:1) | High |
| White on orange accent fails for small text (~3.1:1) | Medium |
| All text uses hardcoded fontSize (no dynamic type support) | Medium |
| GestureDetector used instead of InkWell/IconButton (no focus/a11y) | Medium |

---

## i18n Status

- 21 language files exist but only English enabled at runtime
- 100+ hardcoded English strings in new screens (0% localized)
- Zero RTL language support
- `zh.json` (Chinese Traditional) is empty
