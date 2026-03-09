# Harbr Premium Redesign Plan

## Current State Audit

### What exists
- **80+ shared widgets** in `lib/widgets/ui/` — well-organized, barrel-exported
- **Design tokens** partially defined in `HarbrUI` (spacing, radii, opacity, font sizes)
- **Color system** in `HarbrColours` (accent teal, navy primary, charcoal secondary, 6 semantic colors)
- **Two themes** (Midnight + AMOLED) — both Material 2 (`useMaterial3: false`)
- **Typography** via `HarbrTextStyle` (RobotoFlex, MD3 type scale) — but barely used; most screens use inline `FONT_SIZE_H*` constants
- **HarbrBlock** is the primary list tile — poster + title + subtitles, skeleton support, background image fade
- **GNav** bottom navigation (Google Nav Bar package) — pill-style active tab
- **GoRouter** with enum-based route definitions and mixin pattern
- **ChangeNotifier + Provider** state management throughout

### Problems to solve
1. **Material 2 theme** — `useMaterial3: false`, deprecated APIs (`MaterialStateProperty`, `withOpacity`), no `ThemeExtension` usage
2. **Inconsistent typography** — `HarbrTextStyle` defines MD3 scale but screens use `FONT_SIZE_H*` constants and inline `TextStyle`s
3. **No surface elevation system** — everything is flat (`ELEVATION: 0.0`), cards/sheets/dialogs all use the same `secondary` color with no layering
4. **Weak visual hierarchy** — titles, metadata, status indicators, and actions all compete at similar weights
5. **HarbrBlock does too much** — poster + title + N subtitles + bottom + background + skeleton + leading/trailing in one widget; hard to compose
6. **No status/badge system** — monitored/unmonitored, quality, file status are all just colored text spans
7. **Drawer navigation** — feels dated; hamburger menu + full-height drawer for module switching
8. **No empty/error/loading states design** — `HarbrMessage` is a plain centered text
9. **No responsive layout** — same single-column list on phone, tablet, and desktop
10. **Spacing is okay** — 12dp base unit is fine but `MARGIN_H_DEFAULT_V_HALF` is used everywhere without semantic meaning

---

## Redesign Plan

### Phase 0: Design Tokens & Theme Foundation

**Goal**: Migrate to Material 3, establish a proper token system, and create `ThemeExtension`s.

#### 0.1 — `HarbrTokens` (new file: `lib/widgets/ui/tokens.dart`)

```
Spacing:   xs=4  sm=8  md=12  lg=16  xl=24  xxl=32
Radii:     sm=6  md=10  lg=14  xl=20  pill=999
Elevation: surface=0  raised=1  overlay=4  modal=8
Opacity:   disabled=0.38  medium=0.60  high=0.87
Duration:  fast=150ms  normal=250ms  slow=400ms
```

#### 0.2 — Surface color system

```
canvas:     #0D1117   (deepest background — darker than current)
surface0:   #161B22   (current primary — card/panel background)
surface1:   #1C2128   (current secondary — elevated surfaces)
surface2:   #242A33   (NEW — sheets, dialogs, popovers)
surface3:   #2D333B   (NEW — hover states, active items)
border:     #FFFFFF0F (subtle separation)
borderHigh: #FFFFFF1A (emphasized separation)
```

#### 0.3 — Semantic color tokens

```
accent:     #00BCD4   (primary action)
accentDim:  #00BCD4 @ 15%  (accent backgrounds)
success:    #3FB950   (downloaded, available)
warning:    #D29922   (queued, in progress)
danger:     #F85149   (missing, error, failed)
info:       #58A6FF   (informational)
muted:      #8B949E   (secondary text, disabled)
onSurface:  #E6EDF3   (primary text — slightly off-white)
onSurfaceDim: #8B949E (secondary text)
```

#### 0.4 — Migrate theme to Material 3

- Set `useMaterial3: true`
- Use `ColorScheme.fromSeed` with custom overrides
- Create `HarbrThemeExtension extends ThemeExtension<HarbrThemeExtension>` for custom tokens
- Replace all `withOpacity()` calls with `.withValues(alpha:)` (fixes deprecation warnings)
- Replace `MaterialStateProperty` with `WidgetStateProperty`

#### 0.5 — Typography normalization

- Keep `RobotoFlex` as primary font
- Define semantic text styles: `pageTitle`, `sectionHeader`, `cardTitle`, `cardSubtitle`, `label`, `caption`, `statusText`
- Remove `FONT_SIZE_H*` constants — everything flows from the type scale
- All text styles accessed via `Theme.of(context).extension<HarbrTypography>()`

---

### Phase 1: Core Component Redesign

#### 1.1 — `HarbrSurface` (replaces `HarbrCard`)

A composable surface widget with proper elevation layering:
```dart
HarbrSurface(
  level: SurfaceLevel.raised,  // canvas | base | raised | overlay
  borderRadius: HarbrTokens.radiusMd,
  padding: HarbrTokens.md,
  child: ...,
)
```

#### 1.2 — `HarbrMediaRow` (replaces `HarbrBlock` for list items)

Decomposed, composable media row:
```dart
HarbrMediaRow(
  poster: HarbrPoster(url: ..., size: PosterSize.md),
  title: 'The Dark Knight',
  subtitle: 'Christopher Nolan',
  status: HarbrStatusBadge(type: StatusType.downloaded),
  metadata: [
    HarbrMetaChip(icon: Icons.hd, label: 'Bluray-1080p'),
    HarbrMetaChip(icon: Icons.folder, label: '45.2 GB'),
  ],
  trailing: HarbrMonitorToggle(monitored: true),
  onTap: () => ...,
)
```

Key differences from `HarbrBlock`:
- Status is a first-class badge, not a colored text span
- Metadata chips instead of raw `TextSpan` arrays
- Poster is a standalone widget with size presets
- Monitor toggle is an explicit trailing action
- No more `body: [TextSpan]` — structured data instead

#### 1.3 — `HarbrStatusBadge`

Pill-shaped status indicator:
```
downloaded  → green dot + "Downloaded"
missing     → red dot + "Missing"
queued      → yellow dot + "Queued"
monitored   → accent outline
unmonitored → muted, no outline
```

#### 1.4 — `HarbrMetaChip`

Small inline metadata tag:
```dart
HarbrMetaChip(icon: Icons.movie, label: '2160p')
```
Renders as: `[icon] label` in `caption` style, muted color, compact.

#### 1.5 — `HarbrEmptyState`

Replaces plain `HarbrMessage`:
```dart
HarbrEmptyState(
  icon: Icons.search_off,
  title: 'No Results',
  subtitle: 'Try a different search term',
  action: HarbrButton.text(label: 'Clear Search', onTap: ...),
)
```

#### 1.6 — `HarbrSkeleton` (improved)

Shimmer loading that matches the actual widget shape:
- `HarbrSkeleton.mediaRow()` — matches `HarbrMediaRow` layout
- `HarbrSkeleton.detailHeader()` — matches detail screen hero
- `HarbrSkeleton.grid()` — matches grid view

---

### Phase 2: Navigation Redesign

#### 2.1 — Replace drawer with bottom tab rail

**Current**: Hamburger → full drawer → tap module → page loads with its own bottom tabs
**Proposed**: Single persistent bottom navigation with module switching

```
┌─────────────────────────────────┐
│ [AppBar: Module name + actions] │
├─────────────────────────────────┤
│                                 │
│     [Page content]              │
│                                 │
├─────────────────────────────────┤
│ Module tabs (if in module)      │
│ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│
│ 🏠  📺  🎬  📚  ⚙️            │
│ Home Sonarr Radarr Readarr More │
└─────────────────────────────────┘
```

- Bottom bar shows top-level modules (configurable)
- Within a module, secondary tabs appear as a **top tab bar** (not a second bottom bar)
- Eliminates drawer entirely on mobile
- On tablet/desktop: side rail + content area

#### 2.2 — `HarbrNavRail` (tablet/desktop)

```
┌──────┬──────────────────────────────┐
│  🏠  │                              │
│  📺  │   [Content area]             │
│  🎬  │                              │
│  📚  │                              │
│      │                              │
│  ⚙️  │                              │
└──────┴──────────────────────────────┘
```

- Icons + optional labels
- Collapses to icons-only on narrow tablets
- Active indicator: rounded pill behind icon (MD3 style)

#### 2.3 — Top tab bar for in-module navigation

Replace the current bottom `GNav` within modules with a Material 3 `TabBar`:
```
[Catalogue]  [Upcoming]  [Missing]  [More]
```
- Scrollable if > 4 tabs
- Underline indicator with accent color
- Frees the bottom bar for primary module switching

---

### Phase 3: Screen Redesigns

#### 3.1 — Home / Dashboard

**Current**: 2-page view (Modules grid + Calendar) with bottom tabs
**Proposed**: Single scrollable dashboard

```
┌─────────────────────────┐
│ Harbr          [⚙️] [🔔]│
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │ Active Downloads  3  │ │  ← Summary card (tappable)
│ │ ████████░░ 67%       │ │
│ └─────────────────────┘ │
│                         │
│ Recently Added          │
│ ┌─────┐┌─────┐┌─────┐  │  ← Horizontal scroll
│ │poster││poster││poster│ │
│ │title ││title ││title │ │
│ └─────┘└─────┘└─────┘  │
│                         │
│ Upcoming This Week      │
│ ┌─ Today ─────────────┐ │  ← Grouped by day
│ │ 🎬 Movie Name    Mon│ │
│ │ 📺 Show S02E05   Tue│ │
│ └─────────────────────┘ │
│                         │
│ Missing (12)        →   │  ← Section with "see all"
│ [media row]             │
│ [media row]             │
│ [media row]             │
└─────────────────────────┘
```

#### 3.2 — Catalogue / List Screens

**Current**: Search bar in empty AppBar + flat list of `HarbrBlock` rows
**Proposed**: Sticky search + filter bar, dense list with status indicators

```
┌─────────────────────────┐
│ Readarr    [+] [⚙️]     │
│ [Catalogue][Upcoming]... │  ← Top tabs
├─────────────────────────┤
│ 🔍 Search...   [≡] [⊞] │  ← Search + filter + view toggle
├─────────────────────────┤
│ ┌───────────────────┐   │
│ │🖼 Title           │   │  ← HarbrMediaRow
│ │   Author · 2024   │   │
│ │   🟢 Downloaded   │   │
│ └───────────────────┘   │
│ ┌───────────────────┐   │
│ │🖼 Title           │   │
│ │   Author · 2023   │   │
│ │   🔴 Missing      │   │
│ └───────────────────┘   │
│         ...             │
└─────────────────────────┘
```

Changes:
- Filter/sort as bottom sheet (not hidden behind AppBar)
- Grid view as alternative (poster grid with title overlay)
- Status badges instead of colored text
- Pull-to-refresh preserved
- Alphabet fast-scroll rail on right edge

#### 3.3 — Detail Screen

**Current**: AppBar title + bottom tabs (Overview/History) + flat content
**Proposed**: Hero header + scrollable content sections

```
┌─────────────────────────┐
│ ← Back        [🔗] [⚙️] │
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │   [poster]          │ │  ← Hero: poster + backdrop
│ │   Title             │ │
│ │   Author · 2024     │ │
│ │   🟢 Downloaded     │ │
│ │   [Monitor] [Search]│ │  ← Action buttons
│ └─────────────────────┘ │
│                         │
│ Overview                │
│ ┌─────────────────────┐ │
│ │ Quality  Bluray-1080│ │  ← Key-value table
│ │ Size     45.2 GB    │ │
│ │ Added    2024-01-15 │ │
│ │ Path     /media/... │ │
│ └─────────────────────┘ │
│                         │
│ Description             │
│ Lorem ipsum dolor sit...│
│                         │
│ History (3)             │
│ [history rows]          │
│                         │
│ Files                   │
│ [file rows]             │
└─────────────────────────┘
```

Changes:
- Collapse tabs into single scrollable page with section headers
- Hero area with backdrop blur + poster + key info + actions
- Sticky action buttons (monitor toggle, search, edit, delete)
- Table card for structured metadata
- Section headers with count badges

#### 3.4 — Queue Screen

**Current**: Plain list of queue tiles
**Proposed**: Progress-focused queue with grouping

```
┌─────────────────────────┐
│ Queue (5)        [↻] [⚙️]│
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │ 📺 Show S02E05      │ │
│ │ SABnzbd · 12.4 GB   │ │
│ │ ████████████░░ 87%   │ │  ← Progress bar
│ │ ETA: 4m · 25 MB/s   │ │
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │
│ │ 🎬 Movie Name       │ │
│ │ NZBGet · 8.1 GB     │ │
│ │ ██░░░░░░░░░░░ 12%   │ │
│ │ ETA: 22m · 18 MB/s  │ │
│ └─────────────────────┘ │
│                         │
│ Completed Today         │
│ [completed rows dimmed] │
└─────────────────────────┘
```

Changes:
- Prominent progress bars (accent-colored)
- ETA + speed as secondary metadata
- Swipe actions (remove, blocklist)
- Group by status: Downloading → Queued → Completed
- Empty state: "Queue is empty" with illustration

#### 3.5 — Search / Add Flow

**Current**: AppBar search → list results → configure page → add
**Proposed**: Streamlined search with inline preview

```
Step 1: Search
┌─────────────────────────┐
│ ← 🔍 Search books...    │  ← Autofocus search bar
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │🖼 Book Title        │ │
│ │   Author · 2024     │ │
│ │   ⭐ 4.2 · 📄 320p  │ │
│ │   [+ Add]           │ │  ← Inline add button
│ └─────────────────────┘ │
└─────────────────────────┘

Step 2: Configure (bottom sheet, not new page)
┌─────────────────────────┐
│ Add "Book Title"        │
│                         │
│ Root Folder    [/media] │
│ Quality        [Any]    │
│ Metadata       [Default]│
│ Tags           [none]   │
│ ☑ Start search          │
│                         │
│ [      Add Book       ] │  ← Primary action button
└─────────────────────────┘
```

Changes:
- Configure as bottom sheet instead of separate route (faster)
- Inline "Add" button on search results for quick adds
- Already-added items shown with checkmark + "In Library" badge
- Discover tab with trending/popular suggestions

---

### Phase 4: Responsive Layout

#### 4.1 — Breakpoints

```
compact:   < 600dp   (phone portrait)
medium:    600-839dp  (phone landscape, small tablet)
expanded:  840-1199dp (tablet, small desktop)
large:     ≥ 1200dp   (desktop, large tablet landscape)
```

#### 4.2 — Layout adaptations

| Screen | Compact | Medium | Expanded+ |
|--------|---------|--------|-----------|
| Nav | Bottom bar | Nav rail | Nav rail + labels |
| Lists | Single column | 2-column grid | 3-column grid |
| Details | Full screen | Side panel | Side panel + wider |
| Search | Full screen | Overlay sheet | Side panel |
| Queue | Single column | Single column | 2-column |

---

## Implementation Order

| Priority | Task | Files touched | Risk |
|----------|------|---------------|------|
| P0 | `HarbrTokens` + color system | New file + `colors.dart` + `ui.dart` | Low |
| P0 | Material 3 migration | `theme.dart` | Medium — deprecation fixes |
| P0 | `HarbrThemeExtension` | New file | Low |
| P1 | `HarbrSurface` | New file, update `card.dart` | Low |
| P1 | `HarbrStatusBadge` + `HarbrMetaChip` | New files | Low |
| P1 | `HarbrMediaRow` | New file | Low |
| P1 | `HarbrEmptyState` | Update `message.dart` | Low |
| P2 | Navigation restructure | `scaffold.dart`, `drawer/`, `navigation_bar.dart`, all module routes | High — touches every screen |
| P2 | Top tab bar for modules | Module route files | Medium |
| P3 | Detail screen hero layout | Detail route files | Medium |
| P3 | Queue progress redesign | Queue routes + tiles | Low |
| P3 | Search bottom sheet flow | Add routes | Medium |
| P4 | Dashboard redesign | Dashboard module | Medium |
| P4 | Responsive breakpoints | Layout wrapper | Medium |

---

## Files to create (Phase 0-1)

```
lib/widgets/ui/tokens.dart           — spacing, radii, duration, elevation constants
lib/widgets/ui/theme_extension.dart  — HarbrThemeExtension with custom color/type tokens
lib/widgets/ui/surface.dart          — HarbrSurface composable container
lib/widgets/ui/status_badge.dart     — HarbrStatusBadge pill indicator
lib/widgets/ui/meta_chip.dart        — HarbrMetaChip inline metadata tag
lib/widgets/ui/media_row.dart        — HarbrMediaRow composable list item
lib/widgets/ui/empty_state.dart      — HarbrEmptyState with icon/title/action
lib/widgets/ui/poster.dart           — HarbrPoster standalone image widget
lib/widgets/ui/progress_bar.dart     — HarbrProgressBar for queue items
```

## Files to modify (Phase 0-1)

```
lib/widgets/ui/colors.dart     — add semantic color tokens
lib/widgets/ui/theme.dart      — Material 3 migration
lib/widgets/ui.dart            — export new components, deprecate old constants
lib/widgets/ui/card.dart       — delegate to HarbrSurface internally
```
