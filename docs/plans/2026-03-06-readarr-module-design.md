# Readarr Module Design for Harbr

## Summary
Add full Readarr (book management) support to Harbr, following the existing 6-layer module pattern used by Sonarr/Radarr/Lidarr.

## Architecture
Fork of Harbr. New `readarr` module mirroring Sonarr's structure across all layers: API client, database, state, router, UI routes, and registration points.

## Key Entities

| Readarr Entity | Sonarr Equivalent | API Endpoint |
|----------------|-------------------|--------------|
| Author | Series | `/api/v1/author` |
| Book | Episode (but independently addable) | `/api/v1/book` |
| Edition | None | `/api/v1/edition` |
| MetadataProfile | None | `/api/v1/metadataprofile` |
| QualityProfile | QualityProfile | `/api/v1/qualityprofile` |

## Screens

1. **Home** — Bottom nav: Catalogue, Upcoming, Missing, More
2. **Catalogue** — Author list with book counts, sort/filter
3. **Author Details** — Author info, book list, monitored toggle
4. **Book Details** — Book info, editions, files, history
5. **Add Book** — Search, select profiles/root folder, add
6. **Queue** — Active downloads
7. **History** — Recent activity
8. **Missing** — Wanted but not downloaded
9. **Releases** — Manual search
10. **Tags** — Tag management
11. **Settings** — Connection, defaults

## API Endpoints

- `GET/POST/PUT/DELETE /api/v1/author`
- `GET/POST/PUT/DELETE /api/v1/book`
- `GET /api/v1/book/lookup`
- `GET /api/v1/edition`
- `GET /api/v1/qualityprofile`
- `GET /api/v1/metadataprofile`
- `GET /api/v1/rootfolder`
- `GET /api/v1/tag`
- `GET /api/v1/queue`
- `GET /api/v1/history`
- `GET /api/v1/wanted/missing`
- `GET /api/v1/calendar`
- `POST /api/v1/command`
- `GET /api/v1/release`

## New Files (~80-100)

- `lib/api/readarr/` — API client, controllers, models, types
- `lib/modules/readarr/` — Core (state, dialogs, extensions, webhooks) + UI routes
- `lib/database/tables/readarr.dart` — Hive table
- `lib/router/routes/readarr.dart` — GoRouter routes

## Modified Files (6)

1. `lib/modules.dart` — Add READARR to HarbrModule enum
2. `lib/database/table.dart` — Add readarr table
3. `lib/router/routes.dart` — Add readarr routes
4. `lib/database/models/profile.dart` — Add connection fields (HiveField 44-47)
5. `lib/router/routes/settings.dart` — Add settings routes
6. `lib/modules/settings/` — Add readarr config pages

## Approach
- Approach 1: Fork & Add Module
- Full feature parity with other modules
- Can submit upstream PR later
